class PackagesController < ApplicationController

  def search
    if !params[:name].to_s.blank?
      @packages = Package.search "*#{params[:name]}*"
      @packages.delete_if{|package| package.status != params[:status]}
    else
      flash[:error] = "Please enter some value and press search button."
    end
    render 'index'
  end

  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'name'
    params[:by] = params[:by] || 'ASC'
    @packages = Package.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])

  end

  def new
    @package = Package.new
  end

  def create
    @package = Package.new(params[:package])
    if params[:selected_deposit] == 'None'
      @package.deposit = 'None'
    elsif params[:selected_deposit] == 'Full'
      @package.deposit = 'Full'
    else
      @package.deposit = params[:deposit]
    end
    @package.status = 'Active'
    if @package.save
      @services = Service.all
      if !@services.empty?
        @services.each do |service|
          PackageService.create(:service_id => service.id, :package_id => @package.id, :quantity => params[:"#{service.id}_quantity"])
        end
      end
      #      @package.assign_services(params[:package][:service_ids])
      puts '>>>>>>>>>>>>>>>>>..'
      @package.errors.inspect
      flash[:notice] = "Succcessfully created a new package."
      redirect_to packages_path
    else
      flash.now[:error] = "Couldn't create package, plase try again."
      render :action => 'new'
    end
  end
 

  def show
    @package = Package.find(params[:id])
  end


  def edit
    @package = Package.find(params[:id])
    @services = Service.all
  end

  def update
    @package = Package.find(params[:id])
    if @package.update_attributes(params[:package])
      flash[:notice] = "Succcessfully updated package details."
      redirect_to packages_path
    else
      flash[:error] = "Couldn't update package details, plase try again."
      render :action => 'edit'
    end
  end


  def delete_selected
    if !params[:package_ids].to_a.empty?
      for package_id in params[:package_ids]
        Package.find(package_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Succcessfully deleted selected packages."
    else
      flash[:error] = "Please select atleast one package to delete"
    end
    redirect_to packages_path
  end

  def update_status
    @package = Package.find(params[:id])
    if @package and @package.update_attributes(:status => params[:status])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message
  end

end
