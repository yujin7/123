class RoomsController < ApplicationController
  before_filter :is_admin
 
  def search
    per_page = params[:per_page] || 10
    @room_ids = []
    if !params[:name].to_s.blank?
      @room = Room.search_for_ids "*#{params[:name]}*"
      @room_ids << @room if !@room.empty?
    end
    if !params[:capacity].to_s.blank?
      @room = Room.search_for_ids "*#{params[:capacity]}*"
      @room_ids << @room if !@room.empty?
    end
   
    if !@room_ids.to_s.blank?
      @rooms = Room.find(@room_ids).paginate(:page => params[:page], :per_page => per_page)
    else
      flash[:error] = "Couldn't find any rooms with the search criteria."
      @rooms = [].paginate
    end
    render 'index'
  end

  def update_status
    @room = Room.find(params[:id])
    if @room and @room.update_attributes(:status => params[:status])
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
    @rooms = Room.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])

  end

  def show
    @room= Room.find(params[:id])
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(params[:room])
    @room.status = 'Active'
    if @room.save
      flash[:notice] = "Room was successfully created"
      redirect_to rooms_path
    else
      flash.now[:error] = "Couldn't create the new room, plase try again."
      render new_room_path
    end
  end

  def edit
    @room = Room.find(params[:id])
  end

  def update
    @room = Room.find(params[:id])
    if @room.update_attributes(params[:room])
      flash[:notice] = "Succcessfully updated room details."
      redirect_to rooms_path
    else
      flash[:error] = "Couldn't update room details, plase try again."
      render edit_room_path
    end
  end

  def destroy
    @room = Room.destroy(params[:id])
    redirect_to rooms_path
  end


  def delete_selected
    if !params[:room_ids].to_a.empty?
      for room_id in params[:room_ids]
        Room.find(room_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Succcessfully deleted selected rooms."
    else
      flash[:error] = "Please select atleast one room to delete"
    end
    redirect_to rooms_path
  end


 
end
