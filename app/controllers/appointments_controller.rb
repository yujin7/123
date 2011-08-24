class AppointmentsController < ApplicationController
  before_filter :require_user
  #  before_filter :has_permission?, :only => [:index, :show, :new, :create, :edit, :update, :destroy]

  def build_date_from_params(field_name, params)
    date = params["#{field_name.to_s}(3i)"].to_s+'-'+params["#{field_name.to_s}(2i)"].to_s+'-'+params["#{field_name.to_s}(1i)"].to_s+' '+params["#{field_name.to_s}(4i)"].to_s+':'+params["#{field_name.to_s}(5i)"].to_s+":00"
    return date
  end

  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'guest_id'
    params[:by] = params[:by] || 'ASC'
    @appointments = Appointment.paginate(:all,:page => params[:page] , :per_page=> per_page, :order => params[:order]+ ' '+params[:by])
  end

  def invoice
    @appointment = Appointment.find_by_id(params[:id])
    @people_in_appointments = Appointment.find(:all, :conditions => ["service_enabled=true"])
    @guests = Guest.all
    if !@people_in_appointments.empty?
      ids = @people_in_appointments.map { |app| app.guest_id }.join(',')
      @guests = Guest.find(:all, :conditions => ["id in (#{ids})"])
    end
  end

  def print_invoice
    @appointment = Appointment.find(params[:id])
    @print_invoice = @appointment.appointment_payments.last
  end


  def appointment_payment
    @appointment_payment = AppointmentPayment.new(:customer_name => params[:customer_name], :customer_email => params[:customer_email], :billing_address1 => params[:billing_address1], :billing_address2 => params[:billing_address2],
      :customer_billing_phone => params[:customer_billing_phone],:customer_order_no => params[:customer_order_no], :date_created => params[:date_created], :total => params[:total], :amount_paid => params[:amount_paid], :balance_due => params[:balance_due],
      :payment_mode => params[:payment_mode], :card_type => params[:card_type], :cash => params[:cash], :address1 => params[:address1],:address2 => params[:address2],
      :street => params[:street],:city => params[:city], :phone1 => params[:phone1],:pin_code => params[:pin_code], :country => params[:country],:card_number => params[:card_number], :appointment_id => params[:id])
    if @appointment_payment.save
      flash[:notice] = "Successfully recieved payment for the appointment."
      redirect_to print_invoice_appointment_path(params[:id])
    else
      flash[:error] = "Couldn't recieve payment for the appointment, please try again."
      redirect_to invoice_appointment_path(params[:id])
    end
  end

 
  def search
    @guests = []
    @appointments = []
    if !params[:name].to_s.blank?
      @guest = Guest.search_for_ids "*#{params[:name]}*"
      @guests << @guest if !@guest.empty?
    end
    if !params[:email].to_s.blank?
      @guest = Guest.search_for_ids "*#{params[:email]}*"
      @guests << @guest if !@guest.empty?
    end
    if !params[:phone].to_s.blank?
      @guest = Guest.search_for_ids "*#{params[:phone]}*"
      @guests << @guest if !@guest.empty?
    end
    if !@guests.empty?
      @appointments =  Appointment.paginate(:all, :page => params[:page],:conditions => ["guest_id in(#{@guests.map{|guest_id|guest_id}.join(',')}) and status= '#{params[:status]}'"], :limit => params[:records_per_page])
    else
      flash.now[:error] = "No appointments found for the entered search criteria."
      @appointments = [].paginate
    end
    render :action => 'index'
  end
 

  def show
    @appointment = Appointment.find(params[:id])
  end

  def new
    @appointment = Appointment.new
  end

  def create
    time_in = build_date_from_params('time_in', params[:appointment]).to_datetime
    time_out = build_date_from_params('time_out', params[:appointment]).to_datetime
    @appointment = Appointment.new(params[:appointment])
    pre_appointments = Appointment.count(:conditions => ["? >= time_in and ? <= time_out and employee_id = ?",  time_in,   time_in,  params[:appointment][:employee_id]])
    all_appointments = Appointment.count(:conditions => ["? >= time_in and ? <= time_out and employee_id = ?",  time_out,   time_out ,  params[:appointment][:employee_id]])
    puts pre_appointments
    if pre_appointments == 0 and all_appointments == 0
      if @appointment.save
        flash[:notice] = "Successfully created an appointment for guest #{@appointment.guest.name}."
        redirect_to appointments_path
      else
        flash.now[:error] = "Couldn't create appointment, please enter appropriate values and try again."
        render new_appointment_path
      end
    else
      flash[:error] = "Appointment already exists between the time in and time out you selected for this staff."
      redirect_to appointments_path
    end
  end

  def edit
    @appointment = Appointment.find(params[:id])
  end

  def update
    @appointment = Appointment.find(params[:id])
    if @appointment.update_attributes(params[:appointment])
      flash[:notice] = "Successfully updated details of appointment for guest #{@appointment.guest.name}."
      redirect_to appointments_path
    else
      flash.now[:error] = "Couldn't update appointment details, please enter appropriate values and try again."
      render edit_appointment_path(params[:id])
    end
  end

  def appointments_by_date
    #    if !params[:selected_date].nil? and !params[:selected_date].to_s.blank?
    #      selected_data = params[:selected_date].split('/')
    #      selected_data_date = selected_data[1].to_s+'/'+selected_data[0].to_s+'/'+selected_data[2].to_s
    #    end
    #    selected_date = !selected_data_date.to_s.blank? ? selected_data_date.to_datetime : Date.today.to_datetime
    #    @appointments = Appointment.all(:conditions => ["(time_in > ? AND time_in < ?) or (time_out > ? AND time_out < ?)", selected_date, selected_date + 1, selected_date, selected_date + 1] )
    #    @staffs = ['staff1', 'staff2', 'staff3', 'staff4', 'staff5']
    #    @appointment_hours = {}
    #    if !@appointments.empty?
    #      @appointments.each do |appointment|
    #        a_value = 1
    #        hash_key = !@appointment_hours.keys.include?(appointment.staff.to_s+'_'+appointment.time_in.hour.to_s+'_'+a_value.to_s) ? appointment.staff.to_s+'_'+appointment.time_in.hour.to_s+'_'+a_value.to_s : appointment.staff.to_s+'_'+appointment.time_in.hour.to_s+'_'+(a_value.to_i+1).to_s
    #        appointment_hours_data = {hash_key => [appointment.id, appointment.comments, appointment.time_in, appointment.time_out]}
    #        @appointment_hours = @appointment_hours.merge(appointment_hours_data)
    #      end
    #    end
  end

  def destroy
    if @appointment.destroy(params[:id])
      flash[:notice] = "Successfully deleted the appointment."
    else
      flash[:notice] = "Couldn't delete the appointment, please try again."
    end
    redirect_to appointments_path
  end

end