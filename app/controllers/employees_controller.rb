class EmployeesController < ApplicationController
  before_filter :has_permission?, :only => [:index, :show, :new, :create, :edit, :update, :destroy]

  def search
    per_page = params[:per_page] || 10
    @employee_ids = []
    if !params[:name].to_s.blank?
      @employee = Employee.search_for_ids "*#{params[:name]}*"
      @employee_ids << @employee if !@employee.empty?
    end
    if !@employee_ids.to_s.blank?
      @employees = Employee.find(@employee_ids).paginate(:page => params[:page], :per_page => per_page)
    else
      flash[:error] = "Couldn't find any employees with the search criteria."
      @employees = [].paginate
    end
    render 'index'
  end

  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'name'
    params[:by] = params[:by] || 'ASC'
    @employees = Employee.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])
  end

  def update_status
    @employee = Employee.find(params[:id])
    if @employee and @employee.update_attributes(:status => params[:status])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message 
  end

  def delete_selected
    if !params[:employee_ids].to_a.empty?
      for employee_id in params[:employee_ids]
        Employee.find(employee_id).update_attribute(:status, 'Deleted')
      end
    else
      flash[:error] = "Please select atleast one employee to delete"
    end
    redirect_to employees_path
  end

  def show
    @employee = Employee.find(params[:id])
    @leave_applications = @employee.leave_applications
  end

  def new
    @employee = Employee.new
  end

  def create
    @employee = Employee.new(params[:employee])
    @employee.status = 'Active'
    if @employee.save

      if  !params[:employee][:location_ids].empty?
        params[:employee][:location_ids].each do |location_id|
          EmployeeLocation.create(:location_id => location_id, :employee_id => @employee.id)
        end
      end

      if !params[:employee][:service_ids].empty?
        params[:employee][:service_ids].each do |service_id|
          EmployeeService.create(:employee_id => @employee.id, :service_id => service_id)
        end
      end
     
      flash[:notice] = "Successfully created employee with name #{@employee.name}."
      redirect_to employees_path
    else
      flash.now[:error] = "Couldn't create employee, please try again."
      render :action => 'new'
    end
  end
 
  def assign_role
    @roles = Role.find(:all)
  end

  def edit
    @employee = Employee.find(params[:id])
    @leave_applications = @employee.leave_applications
  end

  def update
    @employee = Employee.find(params[:id])
    if @employee.update_attributes(params[:employee])
      flash[:notice] = "Successfully updated employee details with name #{@employee.name}."
      redirect_to employees_path
    else
      flash.now[:error] = "Couldn't update employee, please try again."
      render :action => "edit"
    end
  end

  def destroy
    if @employee = Employee.destroy(params[:id])
      flash[:notice] = "Successfully deleted employee."
    else
      flash[:error] = "Couldn't delete employee, please try again."
    end
    redirect_to employees_path
  end

end
