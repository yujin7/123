class TaxtypesController < ApplicationController
  
  def search
    per_page = params[:per_page] || 10
    @taxtype_ids = []
    if !params[:name].to_s.blank?
      @taxtype = Taxtype.search_for_ids "*#{params[:name]}*"
      @taxtype_ids << @taxtype if !@taxtype.empty?
    end
    if !@taxtype_ids.to_s.blank?
      @taxtypes = Taxtype.find(@taxtype_ids).paginate(:page => params[:page], :per_page => per_page)
    else
      flash[:error] = "Couldn't find any taxtypes with the search criteria."
      @taxtypes = [].paginate
    end
    render 'index'
    
  end
  
  def update_status
    @taxtype = Taxtype.find(params[:id])
    if @taxtype and @taxtype.update_attributes(:status => params[:status])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message 
    
    
  end

  def delete_selected
    if !params[:taxtype_ids].to_a.empty?
      for taxtype_id in params[:taxtype_ids]
        Taxtype.find(taxtype_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Succcessfully deleted selected tax types."
    else
      flash[:error] = "Please select atleast one tax to delete"
    end
    redirect_to taxtypes_path
  end

  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'name'
    params[:by] = params[:by] || 'ASC'
    @taxtypes = Taxtype.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])

  end

  def show
    @taxtype = Taxtype.find(params[:id])
  end

  def new
    @taxtype = Taxtype.new
  end

  def create
    @taxtype = Taxtype.new(params[:taxtype])
    @taxtype.status = 'Active'
    if @taxtype.save
      flash[:notice] = "Succcessfully created a new tax type."
      redirect_to taxtypes_path
    else
      flash.now[:error] = "Couldn't create the new tax type, plase try again."
      render :action => 'new'
    end

  end

  def edit
    @taxtype = Taxtype.find(params[:id])
  end

  def update
    @taxtype = Taxtype.find(params[:id])
    if @taxtype.update_attributes(params[:taxtype])
      flash[:notice] = "Succcessfully updated tax type details."
      redirect_to taxtypes_path
    else
      flash[:error] = "Couldn't update tax type details, plase try again."
      render :action => 'edit'
    end
  end

  def destroy
    @taxtype = taxtype.destroy(params[:id])
    redirect_to taxtypes_path
  end
end
