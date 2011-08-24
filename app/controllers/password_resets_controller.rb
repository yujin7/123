class PasswordResetsController < ApplicationController
  #
  before_filter :require_no_user
  before_filter :load_user_using_perishable_token, :only => [ :edit, :update ]

  def new
  end

  def create
    #   @user = User.find_by_user_name(params[:login])
    #    @user = User.where(:name => params[:login])
    #    puts ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>....."
    #    puts params[:login]
    @user = User.find_by_login(params[:login])
    if !@user.nil?
      if @user.email == params[:email]
        #      if @user
        @user.deliver_password_reset_instructions!
        flash[:notice] = "Instructions to reset your password have been emailed to you, Please check your mail."
        redirect_to login_path
      else
        flash.now[:error] = "Email doesnot match with login"
        render :action => :new
      end
    else
      flash.now[:error] = "No user was found with login address #{params[:login]}"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if !params[:password].to_s.blank?
      @user.password = params[:password]
      # Only if your are using password confirmation
      @user.password_confirmation = params[:password_confirmation]
      if @user.save
        flash[:success] = "Your password was successfully updated"
        redirect_to root_url
      else
        flash[:error] = "Couldn't change password, please try again."
        render :action => :edit
      end
    else
      flash[:error] = "Password can't be blank."
      render :action => :edit
    end
  end

  private

  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])
    unless @user
      flash[:error] = "We're sorry, but we could not locate your account"
      redirect_to root_url
    end
  end

end




