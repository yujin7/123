class GuestsController < ApplicationController
  before_filter :require_user
  before_filter :has_permission?, :only => [:show, :new, :create, :edit, :update, :destroy]
  require 'csv'
  
  def search
    if !params[:active].nil?
      conditions = ['Inactive']
    elsif  !params[:inactive].nil?
      conditions = ['Active']
    else
      conditions = []
    end
    @guests = Guest.search("*#{params[:guest_query]}*").paginate
    if !conditions.blank?
      @guests =  @guests.delete_if{|result| (conditions.include?(result.status)) or (!Guest.exists?(result.id))}
    else
      flash[:error] = "Couldn't find any guests with the search criteria."
      @guests = [].paginate
    end
    render :action => 'index'
  end

  def csv_import
    begin
      if !params[:file].to_s.blank? and File.extname(params[:file].original_filename) == ".csv"
        content =  params[:file].read
        i = 0
        CSV.parse(content){|record|
          if i == 0
            unless (record[0] == 'Name' and record[1] == 'Email' and record[2] == 'Gender'  and record[3] == 'Status'  and record[4] == 'Date of Birth' and record[5] == 'Date of Anniversay' and  record[6] == 'Billing one' and record[7] == 'Billing two' and record[8] == 'Billing Street' and record[9] == 'Billing City' and record[10] == 'Billing Country' and record[11] == 'Billing pin' and record[12] == 'Billing telephone' and record[13] == 'Billing mobile' and record[14] == 'Shipping one' and record[15] == 'Shipping two' and record[16] == 'Shipping street' and record[17] == 'Shipping city' and record[18] == 'Shipping country' and record[19] == 'Shiping pin' and record[20] == 'Shipping telephone' and record[21] == 'Shipping mobile' and record[22] == 'Email alert' and record[23] == 'Sms alert' and record[24] == 'Spa location' and record[25] == 'Preferred person' and record[26] == 'Preferred staff' and record[27] == 'Membership type' )
              flash[:error] = "Column order or column names are not matching. Please provide proper csv file"
              break
            end
          else
            Guest.create(:name => record[0],
              :email => record[1],
              :gender=> record[2],
              :status=> record[3],
              :date_of_birth=> record[4],
              :date_of_anniversary=> record[5],
              :billing_address_one=> record[6],
              :billing_address_two => record[7],
              :billing_street => record[8],
              :billing_city => record[9],
              :billing_country => record[10],
              :billing_pin_code => record[11],
              :billing_telephone => record[12],
              :billing_mobile => record[13],
              :shipping_address_one => record[14],
              :shipping_address_two => record[15],
              :shipping_street=> record[16],
              :shipping_city=> record[17],
              :shipping_country=> record[18],
              :shipping_pin_code=> record[19],
              :shipping_telephone=> record[20],
              :shipping_mobile=> record[21],
              :email_alerts=> record[22],
              :sms_alerts=> record[23],
              :location_id=> record[24],
              :preferred_person=> record[25],
              :employee_id=> record[26],
              :membership_id=> record[27]
            )
          end
          i = 1
        }
      else
        flash[:error] = "Please upload CSV file only"
      end
    rescue Exception => e
      logger.debug ">>>>>>>>> Upload CSV file error >>>>>>>>>>"
      logger.debug e
      flash[:error] = "Error while reading from CSV. Please upload again"
    end
    redirect_to guests_path
  end

  def csv_guest_form
    render :action => 'csv_import'
  end


  def get_empty_csv
    csv_data = CSV.generate do |csv|
      csv << ["Name", "Email", "Email", "Gender", "Status", "Date of Birth", "Date of Anniversay", "Billing one", "Billing two", "Billing Street", "Billing City", "Billing Country", "Billing pin", "Billing telephone", "Billing mobile", "Shipping one", "Shipping two", "Shipping street", "Shipping city", "Shipping country", "Shiping pin"," Shipping telephone", "Shipping mobile", "Email alert", "Sms alert", "Spa location", "Preferred person", "Preferred staff", "Membership type","Service package"]
    end
    send_data csv_data,
      :type => 'text/csv',
      :disposition => "attachment; filename=guest_download.csv"
  end
  
  def filter_guest
    per_page = params[:per_page] || 10
    if params[:all_guest]
      @guests = Guest.paginate(:all, :order => 'name Asc', :page => params[:page], :per_page => per_page)
    elsif params[:guests_this_week]
      @guests = Guest.paginate(:all, :conditions => ['created_at > ?', 7.days.ago], :order => 'name Asc', :page => params[:page], :per_page => per_page)
    elsif params[:birth_date]
      @guests = Guest.paginate(:all, :conditions => [" MONTH(date_of_birth) = ?", Date.today.month], :order => 'name Asc',:page => params[:page], :per_page => per_page)
    end
    render :action => 'index'
  end

  
  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'name'
    params[:by] = params[:by] || 'ASC'
    @guests = Guest.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])
  end

  def show
    @guest = Guest.find(params[:id])
  end

  def new
    @guest = Guest.new
  end

  def create
    @guest = Guest.new(params[:guest])
    @guest.assign_packages(params[:guest][:packages_ids])
    @guest.status = 'Active'
    if @guest.save and @guest.guest_custom_field.build(params[:guest_custom_field])
      flash[:notice] = "Succcessfully created a new guest."
      redirect_to guests_path
    else
      flash.now[:error] = "Couldn't create guest, please try again."
      render :action => 'new'
    end
  end


  def edit
    @guest = Guest.find(params[:id])
    render :action => "show"
  end

  def update
    @guest = Guest.find(params[:id])
    if @guest.update_attributes(params[:guest])
      
      @guest.assign_packages(params[:guest][:packages_ids])
      if @guest.guest_custom_field
        @guest.guest_custom_field.update_attributes(params[:guest_custom_field])
      else
        GuestCustomField.create(params[:guest_custom_field].merge!({:guest_id => @guest.id}))
      end
      flash[:notice] = "Succcessfully updated the guest details."
      redirect_to guests_path
    else
      flash.now[:error] = "Couldn't update the details of the guest, Please try again."
      render :action => 'show'
    end
  end

  def destroy
    if @guest = Guest.destroy(params[:id])
      flash[:notice] = "Succcessfully deleted the guest."
    end
    redirect_to guests_path
  end

  def update_status
    @guest = Guest.find(params[:id])
    if @guest and @guest.update_attributes(:status => params[:status])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message
  end

  def delete_selected
    if !params[:guest_ids].to_a.empty?
      for guest_id in params[:guest_ids]
        Guest.find(guest_id).update_attribute(:status, 'Deleted')
      end
    else
      flash[:error] = "Please select atleast one guest to delete"
    end
    redirect_to guests_path
  end

  def export_to_xls
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="guest_list.xls"'
    headers['Cache-Control'] = ''
    @guests = Guest.all
    render :layout => false
  end

  def export_pdf
    
  end

  def export_to_csv
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = 'attachment; filename='+Time.now.strftime('%Y-%m-%d')+'guest_list.csv'
    @guests = Guest.all
    render :layout => false
  end

  def custom_fields
    
  end

  def create_custom_field
    if (/^[a-z]|_$/).match(params[:field_name]) and GuestCustomField::CUSTOM_FIELDS.values.include?(params[:field_data_type]) and !GuestCustomField.column_names.include?(params[:id])
      ActiveRecord::Migration.add_column(GuestCustomField, params[:field_name], params[:field_data_type].to_sym)
      render :update do |page|
        #        page.replace_html "custom_field_list", :partial => "custom_field_list"
        flash[:notice] = "Custom field added successfully"
        page.redirect_to custom_fields_guests_path
      end
    else
      render :update do |page|
        page.replace_html "custom_field_error", "Invalid inputs passed"
      end
    end
  end

  def edit_custom_field
    params[:field_name] = params[:id]
    params[:field_data_type] = GuestCustomField.get_column_type(GuestCustomField.get_columns[params[:id]])
    render :update do |page|
      page.replace_html 'custom_field_form' , :partial => "custom_field_form"
    end
  end

  def update_custom_field
    if (/^[a-z]|_$/).match(params[:field_name]) and GuestCustomField::CUSTOM_FIELDS.values.include?(params[:field_data_type]) and !GuestCustomField.column_names.include?(params[:id])
      ActiveRecord::Migration.change_column(GuestCustomField, params[:field_name], params[:field_data_type].to_sym)
      render :update do |page|
        #        page.replace_html "custom_field_list", :partial => "custom_field_list"
        flash[:notice] = "Custom field updated successfully"
        page.redirect_to custom_fields_guests_path
      end
    else
      render :update do |page|
        page.replace_html "custom_field_error", "Invalid inputs passed"
      end
    end
  end
  
  def destroy_custom_field
    if GuestCustomField.column_names.include?(params[:id])
      ActiveRecord::Migration.remove_column(GuestCustomField, params[:id])
      puts GuestCustomField.column_names.to_a
      render :update do |page|
        #        page.replace_html "custom_field_list", :partial => "custom_field_list"
        flash[:notice] = "Custom field deleted successfully"
        page.redirect_to custom_fields_guests_path
      end


    else
      render :update do |page|
        page.alert("No column exists with #{params[:id]}")
      end
    end
  end

  # /guests/:guest_id/appointments
  # view all notifications of a guest
  def appointments
    @guest = Guest.find(params[:id])
    @appointments = Appointment.paginate(:all, :conditions => ["guest_id = ?", params[:id]], :page => params[:page], :per_page => 10)
    render :action => "show"
  end

  # /guests/:guest_id/notes
  # view all notes of a guest
  def notes
    @guest = Guest.find(params[:id])
    render :action => "show"
  end

  def create_note
    if params[:guest_note] and ["progress", "customer"].include?(params[:guest_note][:note_type])
      guest_note = GuestNote.new(params[:guest_note].merge({:user_id => current_user.id, :guest_id => params[:id]}))
      render :update do |page|
        if guest_note.save
          page.insert_html :top, "#{params[:note_type]}_note_list", :partial => "note", :locals => {:note => guest_note}
          page<< "jQuery('##{params[:note_type]}_note_note').val('')"
        else
          page.replace_html "#{params[:note_type]}_note_status", "#{guest_note.errors.empty? ? 'Error while adding note. Please try again' : guest_note.errors.values.flatten.join(', ')}"
        end
      end
    else
      render :update do |page|
        page.replace_html "#{params[:note_type]}_note_status", "<span style='color:red'>Error while adding note. Please try again</span>"
      end
    end
  end

  def delete_note
    guest_note = GuestNote.find(params[:id])
    render :update do |page|
      if guest_note.destroy
        page.remove "note_#{guest_note.id}"
      else
        page.alert('Error while deleting note. Pelase try again')
      end
    end
  end

  def update_field
    @guest = Guest.find(params[:id])
    if params[:field_name]
      @guest.send(params[:field_name]+"=", params[:guest][params[:field_name]])
      render :update do |page|
        if @guest.save(:validate => false)
          page.replace_html "#{params[:field_name]}_status", "Updated successfully"
        else
          page.replace_html "#{params[:field_name]}_status", "<span style='color: red;'>Error while updating. Please try again</span>"
        end
      end
    else
      render :update do |page|
        page.alert('Error while updating. Please try again')
      end
    end
  end

  def purchases
    @guest = Guest.find(params[:id])
    @payments = Payment.paginate(:all, :conditions => ["guest_id = ?", params[:id]], :page => params[:page], :per_page => 10)
    render :action => "show"
  end
end