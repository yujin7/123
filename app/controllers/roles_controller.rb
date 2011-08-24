class RolesController < ApplicationController
  before_filter :is_admin
  def search
    if !params[:active].nil?
      conditions = ['Inactive']
    elsif  !params[:inactive].nil?
      conditions = ['Active']
    else
      conditions = []
    end
    @roles = Role.search("*#{params[:role_query]}*").paginate
    if !conditions.blank?
      @roles =  @roles.delete_if{|result| (conditions.include?(result.status)) or (!Role.exists?(result.id))}
    end
    render :action => 'index'
  end

  def update_status
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message
  end

  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'name'
    params[:by] = params[:by] || 'ASC'
    @roles = Role.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(params[:role])
    @role.status = 'Active'
    if @role.save
      flash[:notice] = "Succcessfully created a new role."
      redirect_to roles_path
    else
      flash.now[:error] = "Couldn't create the new role, plase try again."
      render new_role_path
    end
  end

  def show
    @role = Role.find(params[:id])
    @permission = Permission.all(:select => 'id, name')
    @application_tab = ApplicationTab.all(:select => 'id, name')
  end

  def edit
    @role = Role.find(params[:id])
  end

  def update
    @role = Role.find(params[:id])
    if @role.update_attributes(params[:role])
      flash[:notice] = "Succcessfully updated role details."
      redirect_to roles_path
    else
      flash[:error] = "Couldn't update role details, plase try again."
      render edit_role_path
    end
  end

  def destroy
    @role = Role.destroy(params[:id])
    redirect_to roles_path
  end

  def delete_selected
    if !params[:role_ids].to_a.empty?
      for role_id in params[:role_ids]
        Role.find(role_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Succcessfully deleted selected roles."
    else
      flash[:error] = "Please select atleast one role to delete"
    end
    redirect_to roles_path
  end

  def assign_permission
    @role = Role.find(params[:id])
    @permission = Permission.all(:select => 'id, name')
    @application_tab = ApplicationTab.all(:select => 'id, name')
    status = false
    if !@permission.empty? and !@application_tab.empty?
      @application_tab.each do |tab|
        @permission.each do |perm|
          param_string = perm.name.to_s+'_'+tab.name
          if params[:"#{param_string}"].to_i == 1
            if !PermissionRole.exists?(:role_id => params[:id], :tab_id => tab.id, :permission_id => perm.id)
              PermissionRole.create(:role_id => params[:id], :tab_id => tab.id, :permission_id => perm.id)
              status = true
            end
          else
            if PermissionRole.exists?(:role_id => params[:id], :tab_id => tab.id, :permission_id => perm.id)
              PermissionRole.first(:conditions => ["role_id = ? and tab_id = ? and permission_id = ? ", params[:id], tab.id, perm.id]).destroy
              status = true
            end
          end
        end
      end
    else
      flash[:error] = "The permissions table or application_tabs table is empty, Please check and come back."
    end
    if status == true
      flash[:notice] = "Successfully updated the permissions assigned to #{@role.name} role."
    else
      flash[:error] = "Couldn't update the permissions assigned to #{@role.name} role."
    end
    redirect_to role_path(params[:id])
  end

end

