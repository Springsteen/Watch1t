class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  #bezpolezen e toq index metod no ina4e 6te polzvam index faila za predstawqne na ne6tata
  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end
  
  #not exist no mi trqbva da se napravi
  #POST /user/login
  def login
	if params[:user].blank? || params[:password].blank?
		#vadq error i gi vru6tam nanovo da populvat
	elsif !User.where(user: params[:user],password: Digest::MD5.hexdigest(params[:password])).take.nil?
		#vadq error i gi vru6tam nanovo da populvat
	else
		session[:user_id] = User.where(user: params[:user]).take.id
	end
  end
  
  #bezpolezno
  # GET /users/1
  # GET /users/1.json
  def show
	session[:user_id] = params[:id]
	@logged_user=User.where(id: session[:user_id]).take
  end

  #bezpolezno
  # GET /users/new
  def new
    @users = User.new
  end

  #bezpolezno
  # GET /users/1/edit
  def edit
	@logged_user=User.where(id: session[:user_id]).take
  end

  #pravq acc
  # POST /users
  # POST /users.json
  def create
	if params[:user].blank? || params[:password].blank? || params[:email].blank? || params[:secret_answer].blank? || params[:secret_question].blank?
		#kak se vadi error
		respond_to do |format|
			format.html { render action: 'new'}
		end
	elsif !User.where(user: params[:user]).take.nil?
		respond_to do |format|
			format.html { render action: 'new'}
		end
	else
		require 'digest/md5'
		@user = User.new(:country => params[:country],:skype => params[:skype],:user => params[:user],:password => Digest::MD5.hexdigest(params[:password]),:block_code => 1,:email => params[:email],:email_check => 1,:secret_question => params[:secret_question],:secret_answer => params[:secret_answer])
		#@user = User.new(user_params);
		respond_to do |format|
		  if @user.save
			format.html { redirect_to @user, notice: 'User was successfully created.' }
			format.json { render action: 'show', status: :created, location: @user }
		  else
			format.html { render action: 'new' }
			format.json { render json: @user.errors, status: :unprocessable_entity }
		  end
		end
	end
  end

  #ne go polzvam no 6te mi trqbva samo da e POST i da primerno /users/update
  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #6te go polzvam
  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

  private
  #wtf kakvo e tova :D
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

  #i tova ?
    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params[:user]
    end
end
