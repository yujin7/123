class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  
  def new
    @user = User.new
  end
  
  def signup
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.errors.empty? and @user.save_without_session_maintenance
      @user.activation_instructions
      user_role = Role.find_by_name('User')
      RoleUser.create(:role_id => user_role.id, :user_id => @user.id)
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to login_url
    else
      render :action => :new
    end
  end
  
  def show
    @user = @current_user
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    #    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      @user.assign_roles(params[:user][:role_ids])
      flash[:notice] = "Account updated!"
      redirect_to manage_role_users_path
    else
      render :action => :edit
    end
  end

  def activate
    @user = User.find_using_perishable_token(params[:activation_code], 1.week) || (raise  Exception)
    raise Exception if @user.active?
    if @user.activate!
      flash[:notice] = "Your account has been activated!"
      UserSession.create(@user, false) # Log user in manually
      @user.welcome
      flash[:notice] = "Account activated!"
      redirect_to root_url
    else
      render :action => :new
    end
  end
 
  def manage_role
    @users = User.all
  end

  def new_user
    @user = User.new
  end

  def create_user
    @user = User.new(params[:user])
    if @user.save_without_session_maintenance
      @user.assign_roles(params[:user][:role_ids])
      @user.activation_instructions
      flash[:notice] = "Your account has been created. Please check your e-mail for your account activation instructions!"
      redirect_to root_url
    else
      render :action => :new_user
    end
  end

  def update_name
    @user = User.find(params[:id])
    if @user.update_attribute(:role_id, params[:role_id])
      message = "<span style='color: green'>Updated</span>"
    else
      message = "<span style='color: red'>Error</span>"
    end
    render :text => message
  end


end
