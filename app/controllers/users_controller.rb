class UsersController < ApplicationController
  before_action :set_user
  @logged_user
  require 'digest/md5'
  #POST /user/login
  def login
      if params[:user].blank? || params[:password].blank?
        flash[:user_panel_notice] = "Don't tuch my HTML code"
        redirect_to :back
      elsif User.where(user: params[:user],password: Digest::MD5.hexdigest(params[:password])).take.nil?
        flash[:user_panel_notice] = "Wrong User or password"
        redirect_to :back
      else
        session[:user_id] = User.where(user: params[:user]).take.id
        set_user()
        if @logged_user.ip != request.remote_ip
          UserMailer.email(@logged_user,"Watch1t Team","Computer with IP "+request.remote_ip+" logged in your account.").deliver
          @logged_user.update(:ip => request.remote_ip)
        end
        if @logged_user.email_check != '1'
          flash[:user_panel_notice] = "Please validate your E-Mail."
          redirect_to :back
        else
          redirect_to :back
        end
      end
  end
  
  #GET /user/logout
  def logout
    session[:user_id] = nil;
      redirect_to "/users"
  end

  def validate_email
      if params[:validate_mail_code].blank?
        flash[:user_panel_notice] = "Please Validate your E-Mail."
        redirect_to :back
      elsif @logged_user.email_check != params[:validate_mail_code]
        flash[:user_panel_notice] = "Wrong Validate code."
        redirect_to :back
      else
        @logged_user.update(:email_check => (1).to_s);
        redirect_to :back
      end
  end
  
  # POST /users/create
  def create
    respond_to do |format|
      if params[:user].blank? || params[:password].blank? || params[:email].blank? || params[:secret_answer].blank? || params[:secret_question].blank?
         format.html { redirect_to :back, notice: 'Problem'}
      elsif !User.where(user: params[:user]).take.nil?
        format.html { redirect_to :back, notice: 'This user already exist.'}
      elsif session[:code] != params[:check_code]
        format.html { redirect_to :back, notice: 'Wrong Code.'}
      elsif params[:repeat_password] != params[:password]
        format.html { redirect_to :back, notice: 'Wrong Repeat Password.'}
      elsif !User.where(email: params[:email]).take.nil?
        format.html { redirect_to :back, notice: 'This email already exist.'}
      else
        check_mail_code = Digest::MD5.hexdigest((Time.now.to_i + Random.rand(5000-10)).to_s)
        @user = User.new(:country => params[:country],:skype => params[:skype],:user => params[:user],:password => Digest::MD5.hexdigest(params[:password]),:block_code => 1,:email => params[:email],:email_check => check_mail_code,:secret_question => params[:secret_question],:secret_answer => params[:secret_answer],:ip => request.remote_ip)
        if @user.save
          UserMailer.email(User.where(user: params[:user]).take,"Watch1t Team","Validate Mail Code: "+check_mail_code).deliver
          format.html { redirect_to :back, notice: 'Your account was successfully created.' }
          session.delete(:code)
        else
          format.html { redirect_to :back, notice: 'System Problem' }
          session.delete(:code)
        end
      end
     end
  end
  
  # POST users/update
  def update
    respond_to do |format|
      if @logged_user.password == params[:edit_password]
        password = @logged_user.password
      else
        password = Digest::MD5.hexdigest(params[:edit_password])
      end
      if params[:user].blank? || params[:edit_password].blank? || params[:email].blank? || params[:secret_answer].blank? || params[:secret_question].blank?
         format.html { redirect_to :back, notice: 'Problem'}
      elsif params[:repeat_password] != params[:edit_password]
        format.html { redirect_to :back, notice: 'Wrong Repeat Password.'}
      elsif User.where(user: params[:user]).count >= 1 && @logged_user.user != params[:user]
        format.html { redirect_to :back, notice: 'This user already exist.'}
        check_mail_code = Digest::MD5.hexdigest(Time.now.to_i + Random.rand(5000-10));
        UserMailer.email(User.where(user: params[:user]).take,"Watch1t Team","Validate Mail Code: "+  check_mail_code).deliver
      elsif @logged_user.update(:user => params[:user],:password => password,:email => params[:email],:secret_question => params[:secret_question],:secret_answer => params[:secret_answer],:country => params[:country],:skype => params[:skype])
        format.html { redirect_to :back, notice: 'Your account was successfully updated.' }
      else
        format.html { redirect_to :back, notice: 'System Problem.' }
      end
    end
  end
  
  # GET users/destroy
  def destroy
    session[:user_id] = nil;
    respond_to do |format|
      format.html { redirect_to :back, user_panel_notice: "Your account was successfully deleted." }
    end
  end
  
  private
    def set_user
      if !session[:user_id].nil?
       session[:user_id] = session[:user_id];
       @logged_user=User.find(session[:user_id])
      else
        @logged_user = nil;
      end
    end
end
