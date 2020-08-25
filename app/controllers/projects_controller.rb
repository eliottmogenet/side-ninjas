class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy]

  def index
    @projects = Project.all
  end

  def show
    # @project = Project.find(params[:id])
    @request_participation = @project.participations.find_by(user: current_user)
    @features = @project.features
  end

  def edit
    #Ò@project = Project.find(params[:id])
    @features = @project.features
    @feature = Feature.new
  end

  def update
    # @project = Project.find(params[:id])
    @project.update(params_project)
    @project.user = current_user
    @project.save

    redirect_to project_path
  end

  def new
    @user = current_user
    @project = Project.new
  end

  def create
    @project = Project.new(params_project)
    @user = current_user

    @project.user = @user
    if @project.save
      redirect_to projects_path
    else
      render :new
    end
  end

  def destroy
    # @project = Project.find(params[:id])
    @project.destroy

    redirect_to projects_path(@project)
  end

  private

  def params_project
    params.require(:project).permit(:title, :description, :github_repository, :trello_link, :start_date, :website_link, :tag)
  end

  def set_project
    @project = Project.find(params[:id])
  end
end
