class UsersController < ApplicationController
  before_action :set_user
  @logged_user
  require 'digest/md5'
  #bezpolezen e toq index metod no ina4e 6te polzvam index faila za predstawqne na ne6tata
  # GET /users
  # GET /users.json
  def index
  
  end
  
  #not exist no mi trqbva da se napravi
  #POST /user/login
  def login
	respond_to do |format|
		if params[:user].blank? || params[:password].blank?
			format.html { redirect_to '/users/index', notice: 'Don\'t tuch my HTML code' }
		elsif User.where(user: params[:user],password: Digest::MD5.hexdigest(params[:password])).take.nil?
			format.html { redirect_to '/users/index', notice: "Wrong user or password." }
		else
			session[:user_id] = User.where(user: params[:user]).take.id
			format.html { redirect_to '/users/index', notice: "You was successfully logged in" }
    end
	end
  end
  
  def logout
    session[:user_id] = nil;
    respond_to do |format|
      format.html { redirect_to '/users/index', notice: "You was successfully logged out." }
    end
  end
  
  # GET /users/user_info
  def user_info
  end

  # GET /users/register
  def register
  end

  #bezpolezno
  # GET /users/edit
  def edit
  end

  # POST /users/create
  def create
    respond_to do |format|
      if params[:user].blank? || params[:password].blank? || params[:email].blank? || params[:secret_answer].blank? || params[:secret_question].blank?
         format.html { redirect_to '/users/register', notice: 'Problem'}
      elsif !User.where(user: params[:user]).take.nil?
        format.html { redirect_to '/users/register', notice: 'This user already exist.'}
      elsif session[:code] != params[:check_code]
        format.html { redirect_to '/users/register', notice: 'Wrong Code.'}
      else
        @user = User.new(:country => params[:country],:skype => params[:skype],:user => params[:user],:password => Digest::MD5.hexdigest(params[:password]),:block_code => 1,:email => params[:email],:email_check => 1,:secret_question => params[:secret_question],:secret_answer => params[:secret_answer])
        if @user.save
          format.html { redirect_to '/users/index', notice: 'You was successfully created.' }
          session.delete(:code)
        else
          format.html { redirect_to '/users/register', notice: 'System Problem' }
          session.delete(:code)
        end
      end
     end
  end
  #ima o6te rabota
  def update
    respond_to do |format|
      if @logged_user.password == params[:password]
        password = @logged_user.password
      else
        password = Digest::MD5.hexdigest(params[:password])
      end
      if params[:user].blank? || params[:password].blank? || params[:email].blank? || params[:secret_answer].blank? || params[:secret_question].blank?
         format.html { redirect_to '/users/edit', notice: 'Problem'}
      elsif User.where(user: params[:user]).count >= 1 && @logged_user.user != params[:user]
        format.html { redirect_to '/users/edit', notice: 'This user already exist.'}
      elsif @logged_user.update(:user => params[:user],:password => password,:email => params[:email],:email_check => 1,:secret_question => params[:secret_question],:secret_answer => params[:secret_answer],:country => params[:country],:skype => params[:skype])
        format.html { redirect_to '/users/index', notice: 'You was successfully updated.' }
      else
        format.html { redirect_to '/users/index', notice: 'System Problem.' }
      end
    end
  end
  
  def destroy
    @logged_user.destroy
    session[:user_id] = nil;
    respond_to do |format|
      format.html { redirect_to '/users/index', notice: "You was successfully deleted." }
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
