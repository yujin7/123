class EquipmentsController < ApplicationController
  before_filter :is_admin
 
  def search
    per_page = params[:per_page] || 10
    @equipment_ids = []
    if !params[:name].to_s.blank?
      @equipment = Equipment.search_for_ids "*#{params[:name]}*"
      @equipment_ids << @equipment if !@equipment.empty?
    end
    if !params[:status].to_s.blank?
      @equipment = Equipment.search_for_ids "*#{params[:status]}*"
      @equipment_ids << @equipment if !@equipment.empty?
    end

    if !@equipment_ids.to_s.blank?
      @equipments = Equipment.find(@equipment_ids).paginate(:page => params[:page], :per_page => per_page)
    else
      flash[:error] = "Couldn't find any equipments with the search criteria."
      @equipments = [].paginate
    end
    render 'index'
  end

  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'name'
    params[:by] = params[:by] || 'ASC'
    @equipments = Equipment.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])

  end

  def update_status
    @equipment = Equipment.find(params[:id])
    if @equipment and @equipment.update_attributes(:status => params[:status])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message 
  end

 

  def show
    @equipment= Equipment.find(params[:id])
  end

  def new
    @equipment = Equipment.new
    @locations = Location.all
  end

  def create
    @equipment = Equipment.new(params[:equipment])
    @equipment.status = 'Active'
    @locations = Location.all
    if @equipment.save
      i = 1
      @locations.each do |location|
        if params[:"#{location.id}_selected"] == '1'
          equipments_assigned = params[:"#{location.id}_quantity"].to_i
          out_of_service_assigned = params[:"#{location.id}_out_of_service"].to_i
          actual_assign = equipments_assigned - out_of_service_assigned
          if (actual_assign == 0)
            (1..equipments_assigned).each do |f|
              equipment_code = params[:equipment][:code_number].to_s+"-#{i}"
              LocationEquipment.create(:location_id => location.id, :equipment_id => @equipment.id, :equipment_code_number => equipment_code, :in_service => false)
              i += 1 if i <= params[:equipment][:total_number].to_i
            end
          else
            (1..actual_assign).each do |f|
              equipment_code = params[:equipment][:code_number].to_s+"-#{i}"
              LocationEquipment.create(:location_id => location.id, :equipment_id => @equipment.id, :equipment_code_number => equipment_code, :in_service => true)
              i += 1 if i <= params[:equipment][:total_number].to_i
            end
            (1..out_of_service_assigned).each do |f|
              equipment_code = params[:equipment][:code_number].to_s+"-#{i}"
              LocationEquipment.create(:location_id => location.id, :equipment_id => @equipment.id, :equipment_code_number => equipment_code, :in_service => false)
              i += 1 if i <= params[:equipment][:total_number].to_i
            end
          end
        end
      end
      flash[:notice] = "Successfully created equipment."
      redirect_to equipments_path
    else
      flash[:error] = "Couldn't create equipment record, please try again."
      render new_equipment_path
    end
  end

  def edit
    @equipment= Equipment.find(params[:id])
  end

  def update
    @equipment= Equipment.find(params[:id])
    if @equipment.code_number != params[:equipment][:code_number]
      location_equipments = @equipment.location_equipments
      i = 1
      location_equipments.each do |location_equipment|
        update_code_number = params[:equipment][:code_number].to_s+"-#{i}"
        location_equipment.update_attribute(:equipment_code_number, update_code_number)
        i += 1 if i <= location_equipments.length
      end
    end
    if @equipment.update_attributes(params[:equipment])
      flash[:notice] = "Successfully updated details of equipment."
      redirect_to equipment_path(@equipment.id)
    else
      flash[:error] = "Couldn't update equipment details, please try again."
      render edit_equipment_path
    end
  end

  def destroy
    if @equipment= Equipment.destroy(params[:id])
      flash[:notice] = "Successfully deleted equipment."
    else
      flash[:error] = "Couldn't delete equipment details, please try again."
    end
    redirect_to equipments_path
  end

  def delete_selected
    if !params[:equipment_ids].to_a.empty?
      for equipment_id in params[:equipment_ids]
        Equipment.find(equipment_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Sucessfully deleted the selected records."
    else
      flash[:error] = "Please select atleast one role to delete"
    end
    redirect_to equipments_path
  end

  def update_location_equipment_status
    @location_equipment = LocationEquipment.find(params[:location_equipment_id])
    if @location_equipment and @location_equipment.update_attributes(:in_service => params[:update_status])
      equipment = @location_equipment.equipment
      if params[:update_status] == 'false'
        if equipment.update_attribute(:no_out_of_service, (equipment.no_out_of_service + 1))
          render :update do |page|
            page.replace_html 'update_error', "<span style='color:green'>Updated.</span>"
            page.replace_html 'out_of_service_value', equipment.no_out_of_service
            page.replace_html "#{@location_equipment.id}_assign_update_status", "<span style='color:green'>Updated.</span>"
          end
        else
          render :update do |page|
            page.replace_html 'update_error', "<span style='color:red'>Error, couldn't update out of service.</span>"
          end
        end
      else
        if equipment.update_attribute(:no_out_of_service, (equipment.no_out_of_service - 1))
          render :update do |page|
            page.replace_html 'update_error', "<span style='color:green'>Updated.</span>"
            page.replace_html 'out_of_service_value', equipment.no_out_of_service
            page.replace_html "#{@location_equipment.id}_assign_update_status", "<span style='color:green'>Updated.</span>"
          end
        else
          render :update do |page|
            page.replace_html 'update_error', "<span style='color:red'>Error, couldn't update out of service.</span>"
          end
        end
      end
    else
      render :update do |page|
        page.replace_html "#{@location_equipment.id}_assign_update_status", "<span style='color:red'>Error.</span>"
      end
    end
  end
    
 
end
