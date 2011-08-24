class PermissionsController < ApplicationController
  before_filter :is_admin

  def index
    per_page = params[:per_page] || 10
    @permissions = Permission.all.paginate(:page => params[:page], :per_page => per_page)
  end

  def show
    @permission = Permission.find(params[:id])
  end

  def new
    @permission = Permission.new
  end

  def create
    @permission = Permission.new(params[:permission])
    if @permission.save
      flash[:notice] = "Succcessfully created a new permission."
      redirect_to permissions_path
    else
      flash[:error] = "Couldn't create the new permission, plase try again."
      render new_permission_path
    end
  end

  def edit
    @permission = Permission.find(params[:id])
  end

  def update
    @permission = Permission.find(params[:id])
    if @permission.update_attributes(params[:permission])
      flash[:notice] = "Succcessfully updated permission details."
      redirect_to permissions_path
    else
      flash[:error] = "Couldn't update permission details, plase try again."
      render edit_permission_path
    end

  end

  def destroy
    
  end
  
end
