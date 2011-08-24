class ManageLeavesController < ApplicationController
  def index
    @leave_applications = LeaveApplication.all(:conditions => ["leave_approval != 'deleted'"]).paginate
  end

  def delete_selected
    if !params[:leave_ids].to_a.empty?
      for leave_id in params[:leave_ids]
        LeaveApplication.find(leave_id).update_attribute(:leave_approval, 'deleted')
      end
      flash[:notice] = "Succcessfully deleted selected profiles."
    else
      flash[:error] = "Please select atleast one profile to delete"
    end
    redirect_to manage_leaves_path
  end

  def update_status
    @leave_application = LeaveApplication.find(params[:id])
    if @leave_application and @leave_application.update_attributes(:leave_approval => params[:leave_approval])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message
  end

end
