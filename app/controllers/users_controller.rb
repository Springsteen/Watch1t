class UsersController < ApplicationController

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
	@logged_user=User.where(id: session[:user_id]).take
  end

  # GET /users/register
  def register
    @users = User.new
  end

  #bezpolezno
  # GET /users/edit
  def edit
	@logged_user=User.where(id: session[:user_id]).take
  end

  # POST /users/create
  def create
	if params[:user].blank? || params[:password].blank? || params[:email].blank? || params[:secret_answer].blank? || params[:secret_question].blank?
		respond_to do |format|
			format.html { redirect_to '/users/register_form', notice: 'Problem'}
		end
	elsif !User.where(user: params[:user]).take.nil?
		respond_to do |format|
			format.html { redirect_to '/users/register_form', notice: 'This user already exist'}
		end
	else
		require 'digest/md5'
		@user = User.new(:country => params[:country],:skype => params[:skype],:user => params[:user],:password => Digest::MD5.hexdigest(params[:password]),:block_code => 1,:email => params[:email],:email_check => 1,:secret_question => params[:secret_question],:secret_answer => params[:secret_answer])
		respond_to do |format|
		  if @user.save
			format.html { redirect_to '/users/index', notice: 'You was successfully created.' }
		  else
			format.html { redirect_to '/users/register_form', notice: 'Problem' }
		  end
		end
	end
  end
  #ima o6te rabota
  def update
    respond_to do |format|
      #if User.find(session[:user_id]).update(user_params)
        format.html { redirect_to '/users/index', notice: 'You was successfully updated.' }
      #else
        #format.html { render action: 'edit' }
      #end
    end
  end
  
  def destroy
    User.find(session[:user_id]).destroy
    session[:user_id] = nil;
    respond_to do |format|
      format.html { redirect_to '/users/index', notice: "You was successfully deleted." }
    end
  end
end
