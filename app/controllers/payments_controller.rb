class PaymentsController < ApplicationController

  def index
    per_page = params[:per_page] || 10
    @payments = Payment.paginate(:all,:page => params[:page] , :per_page=> per_page)
  end

  def update_status
    @payment = Payment.find(params[:id])
    if @payment and @payment.update_attributes(:status => params[:status])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message
  end
 

  def new
    @payment = Payment.new
  end

  def create
    @payment = Payment.new(params[:payment])
    @payment.payment_mode = params[:payment_mode]
    if params[:payment_mode] == 'Cash'
      @payment.cash_card_number = params[:cash]
    else
      @payment.cash_card_number = params[:card_type]+'-'+params[:card_number]
    end
    if @payment.save
      #      if !params[:payment][:service_ids].empty?
      #        params[:payment][:service_ids].each do |service_id|
      #          PaymentService.create(:payment_id => @payment.id, :service_id => service_id)
      #        end
      #      end
      @products = Product.all
      if !@products.empty?
        @products.each do |product|
          if params[:"#{product.id}_selected"] == '1'
            PaymentProduct.create(:product_id => product.id, :payment_id => @payment.id, :quantity => params[:"#{product.id}_quantity"], :product_cost => params[:"#{product.id}_amount"])
          end
        end
      end
      flash[:notice] = "Successfully created a payment and assigned products to it."
      redirect_to payment_path(@payment.id)
    else
      render :action => 'new'
    end
  end

  
  def show
    @payment = Payment.find(params[:id])
  end


  def edit
    @payment = Payment.find(params[:id])
  end

  def update
    @payment = Payment.find(params[:id])
    if @payment.update_attributes(params[:payment])
      @payment.assign_services(params[:payment][:service_ids])
      #    @membership.assign_locations(params[:employee][:location_ids])
      redirect_to payments_path
    else
      render :action => "edit"
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    @payment.destroy
    redirect_to payments_path
  end

  def cash_register
    @cash_register_entries = CashRegister.all(:limit => 10, :order => 'cash_on_date ASC')
    @total_cash = Payment.all(:select => "sum(taxable_amount) as total_cash", :conditions => ['Date(created_at) = ?', Date.today])
    @cash_register = CashRegister.new
    @today_register = CashRegister.all(:conditions => ["DATE(cash_on_date) = ?", Date.today])
  end

  def new_entry
    @cash_register = CashRegister.new(params[:cash_register])
    @cash_register.cash_on_date = Time.now.to_datetime
    @cash_register.user_entered_cash = current_user.login
    cash_registers = CashRegister.all(:conditions => ["DATE(cash_on_date) = ?", Date.today])
    if !cash_registers.empty?
      render :update do |page|
        page.replace_html 'cash_register_message', "<span style='color:red'>You have already the cash register for the day.</span>"
      end
    elsif @cash_register.save
      render :update do |page|
        page.replace_html 'cash_register_table', :partial => 'cash_register_table'
        page.replace_html 'cash_register_message', "<span style='color:green'>Successfully entered the amount into register.</span>"
      end
    else
      render :update do |page|
        page.replace_html 'cash_register_message', "<span style='color:red'>Error, please try again.</span>"
      end
    end
  end

  def search_cash_register
    cash_date = params[:cash_on_date].split('/')
    search_cash_date = (cash_date[2].to_s+'/'+cash_date[0].to_s+'/'+cash_date[1].to_s).to_date
    @cash_register_entries = CashRegister.all(:conditions => ["DATE(cash_on_date) = ?", search_cash_date])
    render :update do |page|
      page.replace_html 'cash_register_table', :partial => 'cash_register_table'
      if @cash_register_entries.empty?
        page.replace_html 'cash_register_message', "<span style='color:red'>Didn't find any cash register entries for the date selected.</span>"
      end
    end
  end
  
end








































