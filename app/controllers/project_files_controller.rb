class ProjectFilesController < ApplicationController

  before_action :set_project_file, only: [:show, :edit, :update, :destroy, :set_main]

  # GET /project_files
  # GET /project_files.json
  def index
    @project_files = ProjectFile.all
  end

  # GET /project_files/1
  # GET /project_files/1.json
  def show
  end

  # GET /project_files/new
  def new
    @project_file = ProjectFile.new
  end

  # GET /project_files/1/edit
  def edit
  end

  def set_main
    if @project_file.filepath[0..14] == "/project_files/"
      project_id = params[:project_id]

      project = Project.find(project_id)
      project_files = project.project_files

      project_files.each do |file|
        file.update(is_basic: nil)
      end

      if @project_file.update(is_basic: 1)
        response = 1
      else
        response = 0
      end
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
    is_new = false
    # uploaded_io = params[:project_file][:filename]
    
    (file_exists = upload_file) unless isUrl?
    
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
  def update
    respond_to do |format|
      if @project_file.update(project_file_params)
        format.html { redirect_to @project_file, notice: 'Project file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', notice: 'Project file was not updated.' }
        format.json { render json: @project_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /project_files/1
  # DELETE /project_files/1.json
  def destroy
    @project_file.destroy
    respond_to do |format|
      format.html { redirect_to project_files_url }
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
      params.require(:project_file).permit(:project_id, :filename, :filepath, :is_basic)
    end
    
    def isUrl?
      params[:project_file][:filepath][0..6] == "http://"
    end
    
    def upload_file
      file_exists = true
      uploaded_io = params[:project_file][:filename]
      params[:project_file][:filename] = params[:project_file][:filename].original_filename
      FileUtils.mkdir_p Rails.root.join("public", "project_files", params[:project_file][:filepath]), :mode => 0755
      output_path = Rails.root.join("public", "project_files", params[:project_file][:filepath], params[:project_file][:filename])
      projectFile = ProjectFile.find_by_filename(params[:project_file][:filename])

      if projectFile and projectFile.is_basic
        new_filename = "#{projectFile.updated_at.to_time.to_i.to_s}_#{params[:project_file][:filename]}"
        old_file = output_path
        new_file = Rails.root.join("public", "project_files", params[:project_file][:filepath], new_filename)
        File.rename(old_file, new_file)
        projectFile.filepath= "/project_files/" + params[:project_file][:filepath] + "/" + new_filename
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
      
      params[:project_file][:filepath] = "/project_files/" + params[:project_file][:filepath] + "/" + params[:project_file][:filename]
      return file_exists
    end
end
