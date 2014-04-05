class UserSubscriptionsController < ApplicationController
  before_action :set_user, only: [:delete,:create]
  before_action :set_user_subscription, only: [:delete,:create]
  # GET /user_subscriptions/create/:serie
  def create
    if(@user_subscription.nil?)
      @user_subscription = UserSubscription.new(user_id:@logged_user.id,serie:params[:serie]).save
    end
    redirect_to :back
  end
  
  # GET /user_subscriptions/delete/:serie
  def delete
    @user_subscription.delete
    redirect_to :back
  end

  private
    def set_user_subscription
      @user_subscription = UserSubscription.where(user_id:@logged_user.id,serie:params[:serie]).take
    end

    def set_user
      if(!session[:user_id].nil?)
        @logged_user = User.find(session[:user_id])
      else
        flash[:subsscription_error] = "Please Login first"
        redirect_to :back
      end
    end
end
