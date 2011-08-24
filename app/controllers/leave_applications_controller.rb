class LeaveApplicationsController < ApplicationController
  
  def index
    per_page = params[:per_page] || 10
    @employee = Employee.find(params[:employee_id])
    @leave_applications = @employee.leave_application.paginate(:page => params[:page] , :per_page=> per_page)
  end

  def new
    @employee = Employee.find(params[:employee_id])
    @leave_application = LeaveApplication.new
  end

  def create
    @leave_application = LeaveApplication.new(params[:leave_application])
    @leave_application.employee_id = params[:employee_id]
    @leave_application.leave_approval = "pending_approval"
    if @leave_application.save and UserMailer.leave_application(@leave_application).deliver
      redirect_to employee_path(@leave_application.employee_id)
    else
      render :action => 'new'
    end
  end

  def edit
    @leave_application = LeaveApplication.find(params[:id])
    @leave_application.employee_id = params[:employee_id]
    @employee = @leave_application.employee
  end

  def update
    @leave_application = LeaveApplication.find(params[:id])
    @leave_application.employee_id = params[:employee_id]
    if @leave_application.update_attributes(params[:leave_application])
      redirect_to employee_path(@leave_application.employee_id)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @leave_application = LeaveApplication.find(params[:id])
    @leave_application.destroy
    redirect_to employee_path(@leave_application.employee_id), :notice => "Successfully destroyed leave application."
  end

  def manage_leaves
    @leave_applications = LeaveApplication.all.paginate
  end

  def update_status
    @leave_application = LeaveApplication.find(params[:id])
    if @leave_application and @leave_application.update_attributes(:leave_approval => params[:status])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message
  end
end
