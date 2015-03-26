class ProjectFilesController < ApplicationController
  before_action :valid_user
  before_action :set_project_file, only: [:show, :edit, :update, :destroy, :set_main, :get_file]
  before_action :allowed_file_types, only: :show
  before_action :can_edit, only:  [:show, :edit, :update]
  before_action :set_extension_info, only: [:show, :get_file]

  # GET /project_files
  # GET /project_files.json
  def index
    redirect_to project_path(Project.find(params[:project_id]))
  end

  # GET /project_files/1
  # GET /project_files/1.json
  def show
    if not (@project_file.project.owner?(@current_user.id) or @project_file.project.contributor?(@current_user.id))
      flash[:alert] = :no_access
      if is_url?(@project_file.filepath)
        session[:search_gs] = @project_file.filename
        redirect_to projects_path and return
      else
        redirect_to :root and return
      end
    else
      if @project_file.extension.in?(@allowed_file_types)
        @updated_at = @project_file.getModificationTime
      else
        send_file "#{Rails.root}/private#{@project_file.filepath}" and return
        # "private#{@project_file.filepath}" and return
      end
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
      flash[:alert] = :file_edit_no_access
      redirect_to project_path(Project.find(params[:project_id]))
    end
  end

  # noinspection RubyArgCount
  def set_main
    if @project_file.filepath[0..14] == '/project_files/'
      project_id = params[:project_id]

      project = Project.find(project_id)
      project_files = project.project_files

      project_files.each do |file|
        file.update(is_basic: nil)
      end

      @project_file.update(is_basic: 1) ? response = 1 : response = 0
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
      flash[:alert] = :no_access
      redirect_to :root and return
    end
    @project = Project.find(params[:project_id])
    is_new = false
    # uploaded_io = params[:project_file][:filename]
    
    (file_exists = upload_file) unless is_url?(params[:project_file][:filepath])
    
    @project_file = @project.project_files.where(project_file_params)
    
    if @project_file.empty?
      @project_file = @project.project_files.create(project_file_params)
      @project_file.user_id = @current_user.id
      @project_file.save
      is_new = true
    end
    
    respond_to do |format|
      if is_new
        format.html { redirect_to @project, notice: 'Article was successfully saved.' }
        format.json { render action: 'show', status: :created, location: @project }
      elsif file_exists
        format.html { redirect_to @project, alert: 'An identical file has been already uploaded.' }
        format.json { render action: 'show', status: :unprocessable_entity, location: @project }
      else
        format.html { redirect_to @project, alert: 'Article failed to be saved. It may already exist in this project.' }
        format.json { render action: 'show', status: :unprocessable_entity, location: @project }
      end
    end
  end

  # PATCH/PUT /project_files/1
  # PATCH/PUT /project_files/1.json
  # noinspection RubyArgCount
  def update
    if not @can_edit
      flash[:alert] = :file_edit_no_access
      redirect_to project_path(Project.find(params[:project_id]))
    end
    respond_to do |format|
      if @project_file.update(project_file_params)
        format.html { redirect_to project_project_file_path(@project_file.project, @project_file), notice: 'Project file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', notice: 'Project file was not updated.' }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_files/1
  # DELETE /project_files/1.json
  # noinspection RubyArgCount
  def destroy
    if not @project_file.project.owner?(@current_user.id)
      alert = :file_delete_no_access
    else
      project = @project_file.project
      filename = @project_file.filename

      if delete_file
        if not @project_file.destroy
          alert = :file_delete_error
        else
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
        flash[:alert] = :no_access
        redirect_to :root and return
      end
    end
    
    def is_url?(filepath)
      filepath[0..3] == 'http'
    end
    
    def upload_file
      file_exists = true
      uploaded_io = params[:project_file][:filename]
      params[:project_file][:filename] = params[:project_file][:filename].original_filename
      FileUtils.mkdir_p Rails.root.join('private', 'project_files', params[:project_file][:filepath]), :mode => 0755
      output_path = Rails.root.join('private', 'project_files', params[:project_file][:filepath], params[:project_file][:filename])
      projectFile = ProjectFile.find_by_filename(params[:project_file][:filename])

      if projectFile and projectFile.is_basic
        new_filename = "#{projectFile.updated_at.to_time.to_i.to_s}_#{params[:project_file][:filename]}"
        old_file = output_path
        new_file = Rails.root.join('private', 'project_files', params[:project_file][:filepath], new_filename)
        File.rename(old_file, new_file)
        projectFile.filepath= Rails.root.join('private', 'project_files', params[:project_file][:filepath], new_filename)
        projectFile.filename= new_filename
        projectFile.is_basic= nil
        projectFile.save!
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

      params[:project_file][:filepath] = '/project_files/' + params[:project_file][:filepath] + "/" + params[:project_file][:filename]
      params[:project_file][:filename] = params[:project_file][:filename].to_s[0..params[:project_file][:filename].to_s.rindex('.')-1]
      return file_exists
    end

    def delete_file
      filepath = "#{Rails.root}/private#{@project_file.filepath}"
      if File.file?(filepath)
        return File.delete(filepath)
      else
        return false
      end
    end
end
