class ProfilesController < ApplicationController
  before_filter :is_admin
  require 'csv'
  

  def csv_import
    begin
      if !params[:file].to_s.blank? and File.extname(params[:file].original_filename) == ".csv"
        content =  params[:file].read
        i = 0
        CSV.parse(content){|record|
          if i == 0
            unless record[0].to_s.strip == 'First name' and record[1].to_s.strip == 'Last name' and record[2].to_s.strip == 'Email'  and record[3].to_s.strip == 'Role name'  and record[4].to_s.strip == 'Date of birth' and record[5].to_s.strip == 'Status' and  record[6] == 'Studio' and record[7].to_s.strip == 'Join date' and record[8].to_s.strip == 'Assigned' and record[9] == 'Contact' and record[10].to_s.strip == 'Contact Hp' and record[11].to_s.strip == 'Leave' and record[12].to_s.strip == 'Supervisor' and record[13].to_s.strip == 'Residential address'
              flash[:error] = "Column order or column names are not matching. Please provide proper csv file"
              break
            end
          else
            Profile.create(:first_name => record[0],
              :last_name => record[1],
              :email => record[2],
              :role_name => record[3],
              :date_of_birth => record[4],
              :status => record[5],
              :studio => record[6],
              :studio_joined_date => record[7],
              :studio_assigned => record[8],
              :contact_residence => record[9],
              :contact_hp => record[10],
              :leave_entitlement => record[11],
              :supervisor => record[12],
              :residential_addr => record[13]
            )
          end
          i = 1
        }
      else
        flash[:error] = 'Please Upload csv file only'
      end
    rescue Exception => e
      logger.debug "<<<<<< Upload CSV file error >>>>>>>"
      logger.debug e
      flash[:error] = "Error while reading from CSV. Please upload again"
    end
    redirect_to profiles_path
  end

  def csv_profile_form
    render :action => 'csv_import'
  end

  
  def get_empty_csv
    csv_data = CSV.generate do |csv| 
      csv << ["First name", "Last name", "Email", "Role name", "Date of birth", "Status", "Studio", "Join date", "Assigned", "Contact", "Contact Hp", "Leave", "Supervisor", "Residential address"]
    end
    send_data csv_data,
      :type => 'text/csv',
      :disposition => "attachment; filename=Profile_download.csv"
  end


  
  def export_to_csv
    headers["Content-Type"] ||= 'text/csv'
    headers["Content-Disposition"] = 'attachment; filename='+Time.now.strftime('%Y-%m-%d')+'profile_list.csv'
    @profiles = Profile.all
    render :layout => false
  end


  def export_pdf

  end

  def export_to_xls
    headers['Content-Type'] = "application/vnd.ms-excel"
    headers['Content-Disposition'] = 'attachment; filename="profile_list.xls"'
    headers['Cache-Control'] = ''
    @profiles = Profile.all
    render :layout => false
  end



  def search
    per_page = params[:per_page] || 10
    @profile_ids = []
    if !params[:name].to_s.blank?
      @profile = Profile.search_for_ids "*#{params[:name]}*"
      
      @profile_ids << @profile if !@profile.empty?
    end
    if !params[:email].to_s.blank?
      @profile = Profile.search_for_ids "*#{params[:email]}*"
      @profile_ids << @profile if !@profile.empty?
    end
    if !params[:status].to_s.blank?
      @profile = Profile.search_for_ids "*#{params[:status]}*"
      @profile_ids << @profile if !@profile.empty?
    end
    if !@profile_ids.empty?
      @profiles = Profile.find(@profile_ids).paginate(:page => params[:page], :per_page => per_page)
    else
      @profiles= [].paginate
      flash.now[:error] = "Couldn't find any profiles for the entered search criteria."
    end
    render 'index'
  end
  
  def delete_selected
    if !params[:profile_ids].to_a.empty?
      for profile_id in params[:profile_ids]
        Profile.find(profile_id).update_attribute(:status, 'Deleted')
      end
      flash[:notice] = "Succcessfully deleted selected profiles."
    else
      flash[:error] = "Please select atleast one profile to delete"
    end
    redirect_to profiles_path
  end



  def update_status
    @profile = Profile.find(params[:id])
    if @profile and @profile.update_attributes(:status => params[:status])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message
  end
  
  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'first_name'
    params[:by] = params[:by] || 'ASC'
    @profiles = Profile.paginate(:all, :conditions => ["status !='Deleted'"], :page => params[:page], :per_page => per_page, :order => params[:order]+' '+params[:by])
  end

  def show
    @profile = Profile.find(params[:id])
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(params[:profile])
    @profile.status = 'Active'
    if @profile.save
      flash[:notice] = "Succcessfully created a new profile."
      redirect_to profiles_path
    else
      flash.now[:error] = "Couldn't create the new profile, plase try again."
      render :action => 'new'
    end
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update_attributes(params[:profile])
      flash[:notice] = "Succcessfully updated profile details."
      redirect_to profiles_path
    else
      flash[:error] = "Couldn't update profile details, plase try again."
      render :action => 'edit'
    end
  end

  def destroy
    @profile = Profile.destroy(params[:id])
    redirect_to profiles_path
  end

end