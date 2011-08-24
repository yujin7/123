class HrSystemController < ApplicationController

  def index
    per_page = params[:per_page] || 10
    params[:order] = params[:order] || 'first_name'
    params[:by] = params[:by] || 'ASC'
    @profiles = Profile.paginate(:all,:page => params[:page] , :per_page=> per_page, :order => params[:order]+ ' '+params[:by])
  end

  def search
    per_page = params[:per_page] || 10
    @profile_ids = []
    if !params[:first_name].to_s.blank?
      @profile = Profile.search_for_ids "*#{params[:first_name]}*"
      @profile_ids << @profile if !@profile.empty?
    end
    if !params[:email].to_s.blank?
      @profile = Profile.search_for_ids "*#{params[:email]}*"
      @profile_ids << @profile if !@profile.empty?
    end

    if !@profile_ids.to_s.blank?
      @profiles = Profile.find(@profile_ids).paginate(:page => params[:page], :per_page => per_page)
    end
    render '/profiles/index'

  end
end
