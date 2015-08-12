class ProjectFilesController < ApplicationController
  include Concerns::ForceNonSSL

  before_action :valid_user
  before_action :set_project_file, only: [:show, :show_history, :edit, :update, :destroy, :set_main, :get_file]
  before_action :allowed_file_types, only: :show
  before_action :can_edit, only:  [:show, :edit, :update]
  before_action :set_extension_info, only: [:show, :get_file]
  before_action :set_referer, only: [:show, :edit, :show_history]

  force_non_ssl

  # GET /project_files
  # GET /project_files.json
  def index
    project = Project.find(params[:project_id])
    redirect_to project_path(project)
  end

  # GET /project_files/1
  # GET /project_files/1.json
  def show
    if not (@project_file.project.owner?(@current_user.id) or @project_file.project.contributor?(@current_user.id))
      if is_url?(@project_file.filepath)
        session[:search_gs] = @project_file.filename
        redirect_to projects_path and return
      else
        flash[:alert] = t :no_access
        redirect_to :root and return
      end
    else
      if @project_file.extension.in?(@allowed_file_types)

        # @file_size = File.size("#{Rails.root}/private#{@project_file.filepath}").to_f
      elsif @project_file.extension == 'lnk'
        redirect_to @project_file.filepath
      else
        send_file "#{Rails.root}/private#{@project_file.filepath}" and return
        # "private#{@project_file.filepath}" and return
      end
    end
  end

  def show_history
    if not (@project_file.project.owner?(@current_user.id) or @project_file.project.contributor?(@current_user.id))
      flash[:alert] = t :no_access
      redirect_to :root and return
    else
      @old_files = @project_file.project.project_files.where('reference = ?', @project_file.id).order('id DESC')
      # session[:search_gs] = @project_file.filename
    end
  end

  # POST /project_files/.:id
  def get_file
    send_file "#{Rails.root}/private#{@project_file.filepath}", :disposition => 'inline', :type => @filetype, :x_sendfile => true
  end

  # GET /project_files/new
  def new
    redirect_to project_path(Project.find(params[:project_id]))
  end

  # GET /project_files/1/edit
  def edit
    if not @can_edit
      flash[:alert] = t :file_edit_no_access
      redirect_to project_path(Project.find(params[:project_id]))
    elsif is_url?(@project_file.filepath)
      # session[:search_gs] = @project_file.filename
      respond_to do |format|
        format.html { redirect_to @project_file.project, alert: (t :linked_edit_error) }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # noinspection RubyArgCount
  def set_main
    if @project_file.filepath[0..14] == '/project_files/'
      @project_file.update(is_basic: params[:is_basic]) ? response = 1 : response = 0
    else
      response = t :invalid_main_file
    end

    respond_to do |format|
      format.text { render text: response }
    end
  end

  # POST /project_files
  # POST /project_files.json
  def create
    @project = Project.find(params[:project_id])
    if not (@project.owner?(@current_user.id) or @project.contributor?(@current_user.id))
      flash[:alert] = t :no_access
      redirect_to :root and return
    end

    is_new = false
    # uploaded_io = params[:project_file][:filename]

    # (uploaded_file_params = upload_file) unless (is_url?(params[:project_file][:filepath]) or params[:project_file][:filename].is_a? String)
    if is_url?(params[:project_file][:filepath]) or params[:project_file][:filename].is_a? String
      session[:search_gs] = params[:search_q]
    else
      uploaded_file_params = upload_file
    end

    @project_file = @project.project_files.where(project_file_params)

    if @project_file.empty?
      @project_file = @project.project_files.create(project_file_params)
      @project_file.user_id = @current_user.id
      @project_file.save
      is_new = true
      unless uploaded_file_params.nil?
        unless (uploaded_file_params[:file_id].nil? or not @project_file.is_basic)
          ActiveRecord::Base.record_timestamps = false
          begin
            old_main = @project.project_files.find(uploaded_file_params[:file_id])
            old_main.reference = @project_file.id
            old_main.save
            old_files = @project.project_files.where('reference = ?', uploaded_file_params[:file_id])
            old_files.each do |f|
              f.reference = @project_file.id
              f.save
            end
          ensure
            ActiveRecord::Base.record_timestamps = true  # don't forget to enable it again!
          end
        end
      end
    end

    respond_to do |format|
      if is_new
        format.html { redirect_to @project, notice: (t :file_save_success) }
        format.json { render action: 'show', status: :created, location: @project }
      elsif uploaded_file_params[:file_exists]
        format.html { redirect_to @project, alert: (t :identical_file) }
        format.json { render action: 'show', status: :unprocessable_entity, location: @project }
      else
        format.html { redirect_to @project, alert: (t :file_save_error) }
        format.json { render action: 'show', status: :unprocessable_entity, location: @project }
      end
    end
  end

  # PATCH/PUT /project_files/1
  # PATCH/PUT /project_files/1.json
  # noinspection RubyArgCount
  def update
    if not @can_edit
      flash[:alert] = t :file_edit_no_access
      redirect_to project_path(@project_file.project)
    elsif is_url?(@project_file.filepath)
      flash[:alert] = t :linked_edit_error
      redirect_to @project_file.project
    end
    respond_to do |format|
      if update_file and @project_file.update(project_file_params)
        format.html { redirect_to project_path(@project_file.project), notice: (t :file_edit_success) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', notice: (t :file_edit_error) }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_files/1
  # DELETE /project_files/1.json
  # noinspection RubyArgCount
  def destroy
    if not @project_file.project.owner?(@current_user.id)
      alert = t :file_delete_no_access
    else
      file_id = @project_file.id
      project = @project_file.project
      filename = @project_file.filename

      if delete_file
        if not @project_file.destroy
          alert = t :file_delete_error
        else
          history_files = project.project_files.where('reference = ?', file_id)
          history_files.each do |f|
            @project_file = f
            delete_file
            @project_file.destroy
          end

          notice = "#{(t :pre_file_delete_success)} \"#{filename}\" #{(t :post_file_delete_success)}"
        end
      end
    end

    respond_to do |format|
      format.html { redirect_to project_path(project), :notice => notice, :alert => alert }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_file
      @project_file = ProjectFile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_file_params
      params.require(:project_file).permit(:project_id, :filename, :extension, :filepath, :is_basic)
    end

    def set_referer
      session[:return_to] = '/'
      session[:return_to] = request.referer
    end

    def allowed_file_types
      @allowed_file_types = %w{pdf txt}
    end

    def set_extension_info
      @filetype = ''
      case @project_file.extension
        when 'pdf'
          @filetype = 'application/pdf'
        when 'txt'
          @filetype = 'text/plain'
          @plugin = nil
      end
    end

    def can_edit
      @can_edit = (@project_file.project.owner?(@current_user.id) or @project_file.owner?(@current_user.id))
    end

    def valid_user
      if @current_user.nil?
        flash[:alert] = t :no_access
        redirect_to :root and return
      end
    end

    def is_url?(filepath)
      filepath[0..3] == 'http'
    end

    def upload_file
      file_exists = true
      id = 0
      uploaded_io = params[:project_file][:filename]
      params[:project_file][:filename] = params[:project_file][:filename].original_filename
      FileUtils.mkdir_p Rails.root.join('private', 'project_files', params[:project_file][:filepath]), :mode => 0700
      output_path = Rails.root.join('private', 'project_files', params[:project_file][:filepath], params[:project_file][:filename])

      # tmp_filename = params[:project_file][:filename].to_s[0..params[:project_file][:filename].to_s.rindex('.')-1]
      projectFile = ProjectFile.find_by_filepath('/project_files/' + params[:project_file][:filepath] + '/' + params[:project_file][:filename])

      if projectFile and projectFile.is_basic
        new_filename = "#{projectFile.updated_at.to_time.to_i}_#{projectFile.filename}.#{projectFile.extension}"
        old_file = output_path
        new_file = Rails.root.join('private', 'project_files', params[:project_file][:filepath], new_filename)
        File.rename(old_file, new_file)
        ActiveRecord::Base.record_timestamps = false
        begin
          projectFile.filepath = '/project_files/' + params[:project_file][:filepath] + '/' + new_filename
          projectFile.filename = new_filename[0..new_filename.rindex('.')-1]
          projectFile.save!
        ensure
          ActiveRecord::Base.record_timestamps = true  # don't forget to enable it again!
        end

        # New file should also be a basic file
        params[:project_file][:is_basic] = true
        id = projectFile.id
      end

      if !File.file?(output_path)
        File.open(output_path, 'wb+') do |file|
          file.write(uploaded_io.read)
          file_exists = false
          # print "\n\n\n"
          # puts Docsplit.extract_author(output_path)
          # puts Docsplit.extract_keywords(output_path)
          # puts Docsplit.extract_subject(output_path)
          # puts Docsplit.extract_length(output_path)
          # puts Docsplit.extract_title(output_path)
          # print "\n\n\n"
        end
      end

      params[:project_file][:filepath] = '/project_files/' + params[:project_file][:filepath] + '/' + params[:project_file][:filename]
      params[:project_file][:filename] = params[:project_file][:filename].to_s[0..params[:project_file][:filename].to_s.rindex('.')-1]
      return { :file_exists => file_exists, :file_id => id }
    end

    def update_file
      old_file = "#{Rails.root}/private#{@project_file.filepath}"
      new_file = "#{Rails.root}/private#{@project_file.filepath.gsub(@project_file.filename, params[:project_file][:filename])}"
      if File.rename(old_file, new_file)
        params[:project_file][:filepath] = @project_file.filepath.gsub(@project_file.filename, params[:project_file][:filename])
      end
    end

    def delete_file
      if is_url? @project_file.filepath
        return true
      else
        filepath = "#{Rails.root}/private#{@project_file.filepath}"
        if File.file?(filepath)
          return File.delete(filepath)
        else
          return false
        end
      end
    end
end