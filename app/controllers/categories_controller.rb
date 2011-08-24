class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
  end

  def add_sub_category
    @category = Category.find(params[:id])
    if params[:name].to_s.blank?
      flash[:error] = "Please enter sub-category name and press on create button."
    else
      @sub_category = SubCategory.new(:name => params[:name], :category_id => @category.id)
      if @sub_category.save
        flash[:notice] = "Successfully created sub-category for category #{@category.name}"
      else
        flash[:error] = "Couldn't create sub-category, please try again."
      end
    end
    redirect_to category_path(params[:id])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params[:category])
    if @category.save
      flash[:notice] = "Successfully created category #{@category.name}."
      redirect_to @category, :notice => "Successfully created category."
    else
      flash[:error] = "Couldn't create category, please try again."
      render :action => 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(params[:category])
      flash[:notice] = "Successfully updated category #{@category.name}."
      redirect_to @category
    else
      flash[:error] = "Couldn't update category, please try again."
      render :action => 'edit'
    end
  end

  

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      flash[:notice] = "Successfully deleted category."
    else
      flash[:error] = "Couldn't delete category, please try again."
    end
    redirect_to categories_url
  end

  def delete_sub_category
    @sub_category = SubCategory.find(params[:sub_cat_id])
    if @sub_category.destroy
      params[:notice] = "Successfully deleted the sub-category."
    else
      params[:error] = "Couldn't delete the sub-category, please try again."
    end
    redirect_to category_path(params[:id])
  end

  def get_sub_categories
    @category = Category.find(params[:id])
    @sub_categories = @category.sub_categories
    options = ""
    for sub_category in @sub_categories
      options += "<option value=#{sub_category.id}>#{sub_category.name}</option>"
    end
    render :text => options
  end
end
