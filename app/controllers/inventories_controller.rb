class InventoriesController < ApplicationController

  before_filter :is_product_exists?

  def index
    per_page = params[:per_page] || 10
    @product = Product.find(params[:product_id])
    @inventories = @product.inventories.paginate(:page => params[:page] , :per_page=> per_page)
     
  end

  def new
    @product = Product.find(params[:product_id])
    @inventory = Inventory.new
    @locations = Location.all

  end

  def create
    @inventory = Inventory.new(params[:inventory])
    @inventory.product_id = params[:product_id]
    @inventory.status = 'Active'
    @locations = Location.all
    if @inventory.save
      @locations.each do |location|
        if params[:"#{location.id}_selected"] == '1'
          LocationsProduct.create(:location_id => location.id, :product_id => params[:product_id], :quantity => params[:"#{location.id}_quantity"])
        end
      end
      flash[:notice] = "Inventory is successfully assigned to selected locations."
      redirect_to product_path(@inventory.product_id)
    else
      @product = Product.find(params[:product_id])
      flash.now[:error] = "Inventory creation failed"
      render :action => 'new'
    end
  end

  def edit
    @inventory = Inventory.find(params[:id])
    @inventory.product_id = params[:product_id]
    @product = @inventory.product
  end

  def update
    @inventory = Inventory.find(params[:id])
    @inventory.product_id = params[:product_id]
    if @inventory.update_attributes(params[:inventory])
      redirect_to product_path(@inventory.product_id)
    else
      render :action => 'edit'
    end
  end

  def destroy
    @inventory = Inventory.find(params[:id])
    @inventory.destroy
    redirect_to products_path, :notice => "Successfully destroyed Inventory."
  end

  private

  def is_product_exists?
    unless Product.exists?(:id => params[:product_id])
      flash[:error] = "Please select a product"
      redirect_to products_path
    end
  end
end
