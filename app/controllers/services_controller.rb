class ServicesController < ApplicationController
  before_filter :is_admin
  
  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'service_name'
    params[:by] = params[:by] || 'ASC'
    @services = Service.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])
  end

  def search
    per_page = params[:per_page] || 10
    @service_ids = []
    if !params[:name].to_s.blank?
      @service = Service.search_for_ids "*#{params[:name]}*"
      @service_ids << @service if !@service.empty?
    end
    if !params[:rate].to_s.blank?
      @service = Service.search_for_ids "*#{params[:rate]}*"
      @service_ids << @service if !@service.empty?
    end
    if !params[:duration].to_s.blank?
      @service = Service.search_for_ids "*#{params[:duration]}*"
      @service_ids << @service if !@service.empty?
    end
    if !params[:status].to_s.blank? and !params[:ststus] == "None"
      @service = Service.search_for_ids "*#{params[:status]}*"
      @service_ids << @service if !@service.empty?
    end
    @services = Service.find(@service_ids)
    @services = @services.delete_if{|service| service.status != params[:status]}
    @services = @services.paginate(:page => params[:page], :per_page=> per_page )
    render :action => 'index'
  end

  def show
    @service = Service.find(params[:id])
  end

  def new
    @service = Service.new
    @categories = Category.all
    @sub_categories = SubCategory.all
  end

  def create
    @service = Service.new(params[:service])
    @service.status = 'Active'
    if @service.save
      if params[:applied_to_employee] == '1' and !params[:service][:employee_ids].empty?
        params[:service][:employee_ids].each do |employee_id|
          EmployeesService.create(:employee_id => employee_id, :service_id => @service.id)
        end
      end
      if params[:applied_to_room] == '1' and !params[:service][:room_ids].empty?
        params[:service][:room_ids].each do |room_id|
          RoomService.create(:room_id => room_id, :service_id => @service.id)
        end
      end
      if params[:service][:requires_equipment] == '1' and !params[:service][:equipment_ids].empty?
        params[:service][:equipment_ids].each do |equipment_id|
          EquipmentsService.create(:equipment_id => equipment_id, :service_id => @service.id)
        end
      end
      @products = Product.all
      if !@products.empty?
        @products.each do |product|
          if params[:"#{product.id}_selected"] == '1'
            ProductsService.create(:product_id => product.id, :service_id => @service.id, :quantity => params[:"#{product.id}_quantity"], :product_cost => params[:"#{product.id}_amount"])
          end
        end
      end
      flash[:notice] = "Successfully created service."
      redirect_to services_path
    else
      flash.now[:error] = "Couldn't create the new service, plase try again."
      @categories = Category.all
      @sub_categories = SubCategory.all
      render :action => 'new'
    end
  end

  def edit
    @service = Service.find(params[:id])
    @categories = Category.all
    @sub_categories = SubCategory.all
  end

  def update
    @service = Service.find(params[:id])
    if @service.update_attributes(params[:service])
      flash[:notice] = "Successfully updated service."
      redirect_to services_path
    else
      @categories = Category.all
      @sub_categories = SubCategory.all
      render :action => 'edit'
    end
  end

  def delete_selected
    if !params[:service_ids].to_a.empty?
      for service_id in params[:service_ids]
        Service.find(service_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Succcessfully deleted selected services."
    else
      flash[:error] = "Please select atleast one service to delete"
    end
    redirect_to services_path
  end

  def destroy
    puts "HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH"
    #    puts params[:services]
    #    @service = Service.find(params[:id])
    #    @service.destroy
    #    redirect_to services_url, :notice => "Successfully destroyed service."
  end

  def update_service_rates
    @service = Service.find(params[:id])
    options = "<input type='text' id='package_total_price' name='package[total_price]' value=#{@service.rate} size='30'"
    render :text => options
  end

  def delete_selected_option
    @service = Service.find(params[:id])
    if params[:delete_type] == 'Employee'
      @employee_service = EmployeesService.first(:conditions => ["service_id = ? and employee_id = ?",@service.id, params[:delete_id]])
      if @employee_service and @employee_service.destroy
        render :update do |page|
          page.replace_html 'assigned_employees', :partial => 'assigned_employees'
        end
      else
        render :update do |page|
          page.replace_html 'delete_message', "<span style='color:red'>Couldn't delete employee, please try again</span>"
        end
      end
    elsif params[:delete_type] == 'Room'
      @room_service = RoomService.first(:conditions => ["service_id = ? and room_id = ?",@service.id, params[:delete_id]])
      if @room_service and @room_service.destroy
        render :update do |page|
          page.replace_html 'assigned_rooms', :partial => 'assigned_rooms'
        end
      else
        render :update do |page|
          page.replace_html 'delete_message', "<span style='color:red'>Couldn't delete room, please try again</span>"
        end
      end
    elsif params[:delete_type] == 'Product'
      @product_service = ProductsService.find(params[:delete_id])
      if @product_service and @product_service.destroy
        render :update do |page|
          page.replace_html 'assigned_products', :partial => 'assigned_products'
        end
      else
        render :update do |page|
          page.replace_html 'delete_message', "<span style='color:red'>Couldn't delete product, please try again</span>"
        end
      end
    elsif params[:delete_type] == 'Equipment'
      @equipment_service = EquipmentsService.first(:conditions => ["service_id = ? and equipment_id = ? ",@service.id, params[:delete_id]])
      if @equipment_service and @equipment_service.destroy
        render :update do |page|
          page.replace_html 'assigned_equipments', :partial => 'assigned_equipments'
        end
      else
        render :update do |page|
          page.replace_html 'delete_message', "<span style='color:red'>Couldn't delete equipment, please try again</span>"
        end
      end
    end
  end
end
