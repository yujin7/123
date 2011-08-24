class MembershipsController < ApplicationController
  before_filter :is_admin
  def search
    per_page = params[:per_page] || 10
    @membership_ids = []
    if !params[:name].to_s.blank?
      @membership = Membership.search_for_ids "*#{params[:name]}*"
      @membership_ids << @membership if !@membership.empty?
    end
    if !@membership_ids.to_s.blank?
      @memberships = Membership.find(@membership_ids).paginate(:page => params[:page], :per_page => per_page)
    else
      flash[:error] = "Couldn't find any memberships with the search criteria."
      @memberships = [].paginate
    end
    render 'index'
    
  end

  def update_status
    @membership = Membership.find(params[:id])
    if @membership and @membership.update_attributes(:status => params[:status])
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
    @memberships = Membership.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])

  end

  def show
    @membership = Membership.find(params[:id])
  end

  def new
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(params[:membership])
    puts params[:selected_comission]
    if params[:selected_comission] == 'None'
      @membership.comission = 'None'
    elsif params[:selected_comission] == 'Full'
      @membership.comission = 'Full'
    else
      @membership.comission = params[:comission]
    end
    #    puts params[:membership][:loyalty_rewards]
    @membership.assign_services(params[:membership][:service_ids])
    @membership.status = 'Active'
    if @membership.save
      flash[:notice] = "Succcessfully created a new membership."
      redirect_to memberships_path
    else
      flash.now[:error] = "Couldn't create membership, plase try again."
      render :action => 'new'
    end

  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update_attributes(params[:membership])
      @membership.assign_services(params[:membership][:service_ids])
      #    @membership.assign_locations(params[:employee][:location_ids])
      flash[:notice] = "Succcessfully updated a membership details."
      redirect_to memberships_path
    else
      flash[:error] = "Couldn't update membership details, plase try again."
      render :action => "edit"
    end
  end
  
  def destroy
    if @membership = Membership.destroy(params[:id])
      flash[:notice] = "Succcessfully deleted the membership."
    else
      flash[:error] = "Couldn't delete membership, plase try again."
    end
    redirect_to memberships_path
  end

  def delete_selected
    if !params[:membership_ids].to_a.empty?
      for membership_id in params[:membership_ids]
        Membership.find(membership_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Succcessfully deleted selected memberships."
    else
      flash[:error] = "Please select atleast one employee to delete"
    end
    redirect_to memberships_path
  end

end
