class ProductsController < ApplicationController
  
  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'name'
    params[:by] = params[:by] || 'ASC'
    @products = Product.paginate(:all,:page => params[:page] , :per_page=> per_page, :order => params[:order]+ ' '+params[:by])
  end

  def update_sub_categorie_products
    @sub_categories = SubCategory.find(:all, :conditions => ["category_id = #{params[:id]}"])
    options =""
    for sub_category in @sub_categories
      options += "<option value=#{sub_category.id}>#{sub_category.name}</option>"
    end
    render :update do |page|
      page.replace_html 'sub_categories', options
    end
  end

  def search
    per_page = params[:per_page] || 10
    @product_ids = []
    if !params[:name].to_s.blank?
      @product = Product.search_for_ids "*#{params[:name]}*"
      puts ">>>>>>>>>>>>>>"
      puts params[:name]
      @product_ids << @product if !@product.empty?
    end
    if !@product_ids.to_s.blank?
      @products = Product.find(@product_ids).paginate(:page => params[:page], :per_page => per_page)
    else
      flash[:error] = "Couldn't find any products with the search criteria."
      @products = [].paginate
    end
    render 'index'
  end
  
  def update_status
    @product = Product.find(params[:id])
    if @product and @product.update_attributes(:status => params[:status])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message

  end

  def delete_selected
    if !params[:product_ids].to_a.empty?
      for product_id in params[:product_ids]
        Product.find(product_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Succcessfully deleted selected products."
    else
      flash[:error] = "Please select atleast one product to delete"
    end
    redirect_to products_path
  end

  def show
    @product = Product.find(params[:id])
    @inventories = @product.inventories
  end
  
  def new
    @product = Product.new
  end

  def create
    @product = Product.new(params[:product])
    @product.status = 'Active'
    if @product.save
      flash[:notice] = "Succcessfully created a new product, please create the invertory for the product."
      redirect_to  new_product_inventory_path(@product.id)
    else
      flash[:error] = "Couldn't create the new product, plase try again."
      @sub_categories = SubCategory.all(:select => "id, name", :conditions => ["category_id = #{params[:product][:sub_category_id]}"]) if !params[:product][:sub_category_id].nil?
      render :action => 'new'
    end
  end

  def edit
    @product = Product.find(params[:id])
    @categories = Category.all
    @sub_categories = SubCategory.all
    @inventories = @product.inventories
  end

  def update
      
    @product = Product.find(params[:id])
    if @product.update_attributes(params[:product])
      @product.category_id = params[:name][:category_id]
      @product.sub_category_id = params[:name][:sub_category_id]
      flash[:notice] = "Succcessfully updated product details."
      redirect_to products_path
    else
      flash[:error] = "Couldn't update product details, plase try again."
      render :action => 'edit'
    end
  end

  def destroy
    @product = Product.destroy(params[:id])
    flash[:notice] = "Successfully destroyed product."
    redirect_to products_path
  end

end
