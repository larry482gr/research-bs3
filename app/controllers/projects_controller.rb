class ProjectsController < ApplicationController
  include Concerns::ForceNonSSL
  before_action :valid_user
  before_action :set_referer, only: [:show, :edit, :new]
  before_action :set_project, only: [:show, :edit, :update, :destroy]
  force_non_ssl

  # GET /projects
  # GET /projects.json
  def index
    @projects = @current_user.projects.order('updated_at DESC')
    @search_gs = session[:search_gs] unless session[:search_gs].nil?
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
    # session[:return_to] = '/'
    # session[:return_to] = request.referer unless request.original_fullpath.to_s.in?(request.referer.to_s)
    @owner = @project.owner?(@current_user.id)

    if not @owner
      @contributor = @project.contributor?(@current_user.id)
    end

    if not (@owner or @contributor) and @project.is_private
      flash[:alert] = (t :no_access)
      redirect_to :root and return
    end

    @project_files = @project.project_files.where('reference = ?', 0).order('updated_at DESC')
    @project_citations = get_citations.sort {|x,y| x['cit']<=>y['cit']}

    @search_gs = session[:search_gs] unless session[:search_gs].nil?
    session.delete(:search_gs)
  end

  # GET /projects/new
  def new
    @project = Project.new
    @private_count = private_count
  end

  # GET /projects/1/edit
  def edit
    if not @project.owner?(@current_user.id)
      flash[:alert] = :no_access
      redirect_to :root and return
    end

    @private_count = private_count
  end

  # POST /projects
  # POST /projects.json
  def create
    if @current_user.nil?
      flash[:alert] = :no_access
      redirect_to :root and return
    end
    @project = @current_user.projects.create(project_params)

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: (t :project_created) }
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
        old_project = @project.attributes
        if @project.update(project_params)
          project_params.each do |param|
            key = param[0]
            val = param[1]

            unless old_project[key] == (val)
              @project.history_projects.create({user_id: @current_user.id, from_value: old_project[key],
                                                to_value: val, change_type: key})
            end
          end

          format.html { redirect_to @project, notice: (t :project_updated) }
          format.json { head :no_content }
        else
          @private_count = private_count

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
      project_directory = "#{Rails.root}/private/project_files/#{@project.id/100}/#{@project.id}"
      if Dir.exists? project_directory
        FileUtils.rm_rf project_directory
      end

      @project.project_files.each do |file|
        file.destroy
      end

      Invitation.delete_all(:project_id => @project.id)

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

    def valid_user
      if @current_user.nil?
        flash[:alert] = (t :no_access)
        redirect_to :root and return
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def project_params
      params.require(:project).permit(:title, :description, :is_private)
    end

    def private_count
      private_count = 0
      @current_user.projects.each do |project|
        private_count += 1 if project.is_private and project.owner?(@current_user.id)
      end

      return private_count
    end

    def get_citations
      return @project.get_citations
    end
end
