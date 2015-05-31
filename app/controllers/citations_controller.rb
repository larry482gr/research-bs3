class CitationsController < ApplicationController
  before_action :valid_user
  before_action :set_project, only: [:destroy]

  # DELETE /projects/1/citations/1
  # DELETE /projects/1/citations/1.json
  def destroy
    if @current_user.nil? or not @project.owner?(@current_user.id)
      flash[:alert] = :no_access
      redirect_to :root and return
    else
      result = @project.delete_citation params[:id]

      if result == 1
        flash[:notice] = t :citation_deleted
      else
        flash[:alert] = "#{t :cite_delete_error} #{t :try_again} #{t :error_persists}"
      end

      respond_to do |format|
        format.html { redirect_to @project }
        format.json { head :no_content }
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:project_id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = Project.find(params[:project_id])
  end

  def valid_user
    if @current_user.nil?
      flash[:alert] = (t :no_access)
      redirect_to :root and return
    end
  end

end