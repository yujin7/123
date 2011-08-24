class LocationsController < ApplicationController
  before_filter :is_admin, :except => [:get_outlets]

  def search
    per_page = params[:per_page] || 10
    @location_ids = []
    if !params[:name].to_s.blank?
      @location = Location.search_for_ids "*#{params[:name]}*"
      @location_ids << @location if !@location.empty?
    end
    if !params[:city].to_s.blank?
      @location = Location.search_for_ids "*#{params[:city]}*"
      @location_ids << @location if !@location.empty?
    end

    if !params[:country].to_s.blank?
      @location = Location.search_for_ids "*#{params[:country]}*"
      @location_ids << @location if !@location.empty?
    end
    if !@location_ids.to_s.blank?
      @locations = Location.find(@location_ids).paginate(:page => params[:page], :per_page => per_page)
    else
      flash[:error] = "Couldn't find any locations with the search criteria."
      @locations = [].paginate
    end
    render 'index'
  end

  def update_status
    @location = Location.find(params[:id])
    if @location and @location.update_attributes(:status => params[:status])
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
    @locations = Location.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])
  end

  def show
    @location = Location.find(params[:id])
    cweek = Date.today.cweek
    @current_wkBegin = Date.commercial(Date.today.year, cweek, 1)
    @current_wkEnd = Date.commercial(Date.today.year, cweek, 7)
    @location_operating_hours = LocationOperationHour.all(:conditions => ["operating_date in(?) and location_id = ?",  (@current_wkBegin..@current_wkEnd), params[:id]])
    @selected_open_hours = @location_operating_hours.map{ |open_hour| (open_hour.operating_date.to_s+' '+(open_hour.open_time.hour.to_s.length == 1 ? '0'+open_hour.open_time.hour.to_s : open_hour.open_time.hour.to_s)+':'+(open_hour.open_time.min.to_s.length ==1 ? '0'+open_hour.open_time.min.to_s : open_hour.open_time.min.to_s ))}.join(',')
    @selected_close_hours = @location_operating_hours.map{ |close_hour| (close_hour.operating_date.to_s+' '+(close_hour.close_time.hour.to_s.length == 1 ? '0'+close_hour.close_time.hour.to_s : close_hour.close_time.hour.to_s)+':'+(close_hour.close_time.min.to_s.length ==1 ? '0'+close_hour.close_time.min.to_s : close_hour.close_time.min.to_s ))}.join(',')
    @location_closed_dates = @location.location_closed_dates
  end

  def new
    @location = Location.new
  end

  def create
    @location = Location.new(params[:location])
    @location.status = 'Active'
    if @location.save
      flash[:notice] = "Succcessfully created a new location, please continue by setting operating hours for the location."
      redirect_to get_operation_hours_location_path(@location.id)
    else
      flash[:error] = "Couldn't create location, plase try again."
      render new_location_path
    end
  end

  def edit
    @location = Location.find(params[:id])
  end

  def update
    @location = Location.find(params[:id])
    if @location.update_attributes(params[:location])
      flash[:notice] = "Succcessfully updated location details."
      redirect_to location_path(@location)
    else
      flash[:error] = "Couldn't update location details, plase try again."
      render edit_location_path
    end
  end

  def destroy
    if @location = location.destroy(params[:id])
      flash[:notice] = "Succcessfully deleted the location."
    else
      flash[:error] = "Couldn't delete the location, plase try again."
    end
    redirect_to locations_path
  end

  def delete_selected

    if !params[:location_ids].to_a.empty?
      for location_id in params[:location_ids]
        Location.find(location_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Succcessfully deleted the selected locations."
    else
      flash[:error] = "Please select atleast one location to delete"
    end
    redirect_to locations_path
  end

  def get_operation_hours
    @location = Location.find(params[:id])
    @location_operation_hour = LocationOperationHour.new
  end

  def create_operation_hours
    @location = Location.find(params[:id])
    save_status = false
    (("01/01/2011".to_datetime)..("12/31/2011".to_datetime)).each do |store_day|
      if LocationOperationHour.create(:location_id => @location.id, :operating_day => store_day.strftime('%A'), :operating_date => store_day.to_date, :open_time => params[:"#{store_day.strftime('%A')}_open_time"], :close_time => params[:"#{store_day.strftime('%A')}_close_time"] )
        save_status = true
      end
    end
    if save_status == true
      flash[:notice] = "Successfully created operating hours for regular schedule, you can set schedule on specific dates and closed dates for location from the show page of location."
      redirect_to location_path(@location.id)
    else
      flash[:error] = "Couldn't set the operating hours for location, please try again with appropriate values."
      render get_operation_hours_location_path(@location.id)
    end
  end

  def show_operation_hours_on_date
    @location = Location.find(params[:id])
    if params[:wkBegin].to_s.blank?
      render :update do |page|
        page.replace_html 'operation_hours_table_errors', 'Error, please select proper range.'
      end
    else
      @current_wkBegin = params[:wkBegin].to_date
      @current_wkEnd = @current_wkBegin + 6
      @location_operating_hours = LocationOperationHour.all(:conditions => ["operating_date in(?) and location_id = ?",  (@current_wkBegin..@current_wkEnd), params[:id]])
      @selected_open_hours = @location_operating_hours.map{ |open_hour| (open_hour.operating_date.to_s+' '+(open_hour.open_time.hour.to_s.length == 1 ? '0'+open_hour.open_time.hour.to_s : open_hour.open_time.hour.to_s)+':'+(open_hour.open_time.min.to_s.length ==1 ? '0'+open_hour.open_time.min.to_s : open_hour.open_time.min.to_s ))}.join(',')
      @selected_close_hours = @location_operating_hours.map{ |close_hour| (close_hour.operating_date.to_s+' '+(close_hour.close_time.hour.to_s.length == 1 ? '0'+close_hour.close_time.hour.to_s : close_hour.close_time.hour.to_s)+':'+(close_hour.close_time.min.to_s.length ==1 ? '0'+close_hour.close_time.min.to_s : close_hour.close_time.min.to_s ))}.join(',')
      render :update do |page|
        page.replace_html 'operation_hours_table', :partial => 'operation_hours'
      end
    end
  end

  def update_operation_time
    @location = Location.find(params[:id])
    @location_operating_hour = LocationOperationHour.first(:conditions => ["operating_date = ? and location_id = ?", params[:operate_date].to_date, params[:id]])
    location_open_time = (params[:time_value].to_time.year.to_s+'-'+(params[:time_value].to_time.month.to_s.length == 1 ? '0'+params[:time_value].to_time.month.to_s : params[:time_value].to_time.month.to_s )+'-'+(params[:time_value].to_time.day.to_s.length == 1 ? '0'+params[:time_value].to_time.day.to_s : params[:time_value].to_time.day.to_s)+' '+(@location_operating_hour.open_time.hour.to_s.length == 1 ? '0'+@location_operating_hour.open_time.hour.to_s : @location_operating_hour.open_time.hour.to_s)+':'+(@location_operating_hour.open_time.min.to_s.length == 1 ? '0'+@location_operating_hour.open_time.min.to_s : @location_operating_hour.open_time.min.to_s)).to_time
    location_close_time = (params[:time_value].to_time.year.to_s+'-'+(params[:time_value].to_time.month.to_s.length == 1 ? '0'+params[:time_value].to_time.month.to_s : params[:time_value].to_time.month.to_s )+'-'+(params[:time_value].to_time.day.to_s.length == 1 ? '0'+params[:time_value].to_time.day.to_s : params[:time_value].to_time.day.to_s)+' '+(@location_operating_hour.close_time.hour.to_s.length == 1 ? '0'+@location_operating_hour.close_time.hour.to_s : @location_operating_hour.close_time.hour.to_s)+':'+(@location_operating_hour.close_time.min.to_s.length == 1 ? '0'+@location_operating_hour.close_time.min.to_s : @location_operating_hour.close_time.min.to_s)).to_time
    if @location_operating_hour.nil?
      message = "<span style='color: red'>Error, please try again.</span>"
    elsif params[:schedule_type] == 'open_time' and (location_close_time <= params[:time_value].to_time)
      message = "<span style='color: red'>*Should be less than close time</span>"
    elsif params[:schedule_type] == 'close_time' and (location_open_time >= params[:time_value].to_time)
      message = "<span style='color: red'>*Should be more than open time</span>"
    elsif @location_operating_hour.update_attribute(:"#{params[:schedule_type]}", params[:time_value].to_time)
      message = "<span style='color: green'>Sucessfully updated timings.</span>"
    end
    render :text => message
  end

  def closed_dates
    @location = Location.find(params[:id])
    @location_closed_dates = @location.location_closed_dates
    @location_closed_date = LocationClosedDate.new
  end

  def new_closed_date
    @location = Location.find(params[:id])
    @location_closed_date = LocationClosedDate.new
    render :update do |page|
      page << "$('#closed_dates_messages').hide()"
      page.replace_html 'closed_date_form', :partial => 'closed_dates_form'
      page << "$('#closed_date_form').show()"
    end
  end

  def add_closed_date
    @location = Location.find(params[:id])
    if params[:location_closed_date][:closed_date].to_s.blank? or params[:location_closed_date][:description].to_s.blank?
      render :update do |page|
        page << "$('#closed_dates_messages').show()"
        page.replace_html 'closed_dates_messages', "<span style='color:red; background-color:#EDEDED;'>Please select closed date and enter the description for closing date.</span>"
      end
    else
      closed_date = params[:location_closed_date][:closed_date].split('/')
      enter_closed_date = (closed_date[2].to_s+'/'+closed_date[0].to_s+'/'+closed_date[1].to_s).to_date
      if LocationClosedDate.exists?(:closed_date => enter_closed_date)
        render :update do |page|
          page << "$('#closed_dates_messages').show()"
          page.replace_html 'closed_dates_messages', "<span style='color:red; background-color:#EDEDED;'>Record already exists by this date, please check the details in the table.</span>"
        end
      else
        @location_closed_date = LocationClosedDate.new(params[:location_closed_date])
        @location_closed_date.closed_date = enter_closed_date
        @location_closed_date.location_id = @location.id
        @location_closed_date.created_by = current_user.login
        if @location_closed_date.save
          @location_closed_dates = @location.location_closed_dates
          @location_closed_date = LocationClosedDate.new
          render :update do |page|
            page.replace_html 'closed_date_form', :partial => 'closed_dates_form'
            page << "$('#closed_date_form').hide()"
            page.replace_html 'closed_date_table', :partial => 'closed_dates_table'
            page << "$('#closed_dates_messages').show()"
            page.replace_html 'closed_dates_messages', "<span style='color:green; background-color:#EDEDED;'>Successfully created a closed date.</span>"
          end
        else
          render :update do |page|
            page << "$('#closed_dates_messages').show()"
            page.replace_html 'closed_dates_messages', "<span style='color:red; background-color:#EDEDED;'>Error, couldn't create closed date. Please try again.</span>"
          end
        end
      end
    end
  end

  def edit_closed_date
    @location = Location.find(params[:id])
    @location_closed_date = LocationClosedDate.find(params[:closed_date_id])
    render :update do |page|
      page << "$('#closed_dates_messages').hide()"
      page.replace_html 'closed_date_form', :partial => 'closed_dates_form'
      page << "$('#closed_date_form').show()"
    end
  end

  def update_closed_date
    @location = Location.find(params[:id])
    if params[:location_closed_date][:closed_date].to_s.blank? or params[:location_closed_date][:description].to_s.blank?
      render :update do |page|
        page << "$('#closed_dates_messages').show()"
        page.replace_html 'closed_dates_messages', "<span style='color:red; background-color:#EDEDED;'>Please select closed date and enter the description for closing date.</span>"
      end
    else
      closed_date = params[:location_closed_date][:closed_date].split('/')
      if closed_date[0].to_s.length == 4
        enter_closed_date = params[:location_closed_date][:closed_date]
      else
        enter_closed_date = (closed_date[2].to_s+'/'+closed_date[0].to_s+'/'+closed_date[1].to_s).to_date
      end
      @location_closed_date = LocationClosedDate.find(params[:closed_date_id])
      if @location_closed_date.nil?
        render :update do |page|
          page << "$('#closed_dates_messages').show()"
          page.replace_html 'closed_dates_messages', "<span style='color:red; background-color:#EDEDED;'>Record doesn't exists by this date, please refresh the page and check again.</span>"
        end
      else
        if @location_closed_date.update_attributes(:closed_date => enter_closed_date, :description => params[:location_closed_date][:description])
          @location_closed_dates = @location.location_closed_dates
          @location_closed_date = LocationClosedDate.new
          render :update do |page|
            page.replace_html 'closed_date_form', :partial => 'closed_dates_form'
            page << "$('#closed_date_form').hide()"
            page.replace_html 'closed_date_table', :partial => 'closed_dates_table'
            page << "$('#closed_dates_messages').show()"
            page.replace_html 'closed_dates_messages', "<span style='color:green; background-color:#EDEDED;'>Successfully updated closed date details.</span>"
          end
        else
          render :update do |page|
            page << "$('#closed_dates_messages').show()"
            page.replace_html 'closed_dates_messages', "<span style='color:red; background-color:#EDEDED;'>Error, couldn't update closed date details. Please try again.</span>"
          end
        end
      end
    end
  end
  
  def delete_closed_date
    @location = Location.find(params[:id])
    @location_closed_date = LocationClosedDate.find(params[:closed_date_id])
    if @location_closed_date.nil?
      render :update do |page|
        page << "$('#closed_dates_messages').show()"
        page.replace_html 'closed_dates_messages', "<span style='color:red; background-color:#EDEDED;'>Record doesn't exists by this date, please refresh the page and check again.</span>"
      end
    elsif @location_closed_date.destroy
      @location_closed_dates = @location.location_closed_dates
      @location_closed_date = LocationClosedDate.new
      render :update do |page|
        page.replace_html 'closed_date_table', :partial => 'closed_dates_table'
        page << "$('#closed_dates_messages').show()"
        page.replace_html 'closed_dates_messages', "<span style='color:green; background-color:#EDEDED;'>Successfully updated closed date details.</span>"
      end
    else
      render :update do |page|
        page << "$('#closed_dates_messages').show()"
        page.replace_html 'closed_dates_messages', "<span style='color:red; background-color:#EDEDED;'>Error, couldn't update closed date details. Please try again.</span>"
      end
    end
  end


  def get_outlets
    @locations = Location.find(:all, :conditions => ['country = ?', params[:country]], :select => 'id,name')
    location_options = ''
    @locations.each do |location|
      location_options += "<option value='#{location.id}'>#{location.name}</option>"
    end
    render :text => location_options
  end


end