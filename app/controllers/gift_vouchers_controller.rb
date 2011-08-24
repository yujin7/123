class GiftVouchersController < ApplicationController

  def index
    per_page = params[:per_page] || 10
    @gift_vouchers = GiftVoucher.paginate(:all,  :page => params[:page], :per_page => per_page)
  end

  def show
    @gift_voucher = GiftVoucher.find(params[:id])
  end

  def new
    @gift_voucher = GiftVoucher.new
  end

  def create
    @gift_voucher = GiftVoucher.new(params[:gift_voucher])
    if @gift_voucher.save
      flash[:notice] = "Succcessfully created a new gift voucher."
      redirect_to gift_vouchers_path
    else
      flash[:error] = "Couldn't create gift voucher, plase try again."
      render :action => 'new'
    end
  end


  def edit
    @gift_voucher = GiftVoucher.find(params[:id])
  end

  def update
    @gift_voucher = GiftVoucher.find(params[:id])
    if @gift_voucher.update_attributes(params[:gift_voucher])
      flash[:notice] = "Succcessfully updated gift voucher details."
      redirect_to  gift_vouchers_path
    else
      flash[:error] = "Couldn't update gift voucher details, plase try again."
      render :action => 'edit'
    end
  end


  def destroy
    if @gift_voucher = GiftVoucher.destroy(params[:id])
      flash[:notice] = "Succcessfully deleted gift voucher."
    else
      flash[:error] = "Couldn't delete gift voucher, plase try again."
    end
    redirect_to gift_vouchers_path
  end
  
end
