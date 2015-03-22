class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  before_action :set_referer, only: [:show, :edit, :new]

  # GET /projects
  # GET /projects.json
  def index
    if @current_user.nil?
      flash[:alert] = :no_access
      redirect_to :root and return
    end

    @projects = @current_user.projects
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    # session[:return_to] = '/'
    # session[:return_to] = request.referer unless request.original_fullpath.to_s.in?(request.referer.to_s)
  	@updated_at = @project.getModificationTime
  	@project_files = @project.project_files

    @owner = @project.owner?(@current_user.id)

    if not @owner
      @contributor = @project.contributor?(@current_user.id)
    end
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
    if @current_user.nil? or not @project.owner?(@current_user.id)
      flash[:alert] = :no_access
      redirect_to :root and return
    end
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = @current_user.projects.create(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render action: 'show', status: :created, location: @project }
      else
        format.html { render action: 'new' }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
  def update
    if @current_user.nil? or not @project.owner?(@current_user.id)
      flash[:alert] = :no_access
      redirect_to :root and return
    else
      respond_to do |format|
        if @project.update(project_params)
          format.html { redirect_to @project, notice: 'Project was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: 'edit' }
          format.json { render json: @project.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /projects/1
  # DELETE /projects/1.json
  def destroy
    if @current_user.nil? or not @project.owner?(@current_user.id)
      flash[:alert] = :no_access
      redirect_to :root and return
    else
      @project.destroy
      respond_to do |format|
        format.html { redirect_to projects_url }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find(params[:id])
    end

    def set_referer
      session[:return_to] = '/'
      session[:return_to] = request.referer unless request.original_fullpath.to_s.in?(request.referer.to_s)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :is_private)
    end
end
