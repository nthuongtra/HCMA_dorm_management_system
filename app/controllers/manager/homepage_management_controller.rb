class Manager::HomepageManagementController < ApplicationController
  layout 'manager_layout/manager'
  def index
    @posts = Post.all
  end

  def show
    # @post = Post.find(params[:id])
  end
end
