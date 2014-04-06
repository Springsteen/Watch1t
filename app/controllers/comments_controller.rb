class CommentsController < ApplicationController
  before_action :set_user, only: [:post ,:edit, :delete]
  before_action :set_comment, only: [:edit, :delete,:edit_menu,:show]

  
  # GET /show/:comment_id
  def show
    
  end
  # POST /comments/post
  def post
    @comment = Comment.new(:user => @logged_user.user,:content => params[:comment],:title => params[:title],:episode_id => params[:episode],:season_id => params[:season],:serie_id => params[:serie])
    if @comment.save
      flash[:notice_comment] = 'Comment was successfully created.';
      redirect_to :back
    else
      flash[:notice_comment] = 'Problem';
      redirect_to :back
    end
  end

  # POST comments/edit
  def edit
    if @comment.update(:title => params[:title],:content => params[:comment])
      redirect_to :back
    else
      redirect_to :back
    end
  end
  def edit_menu
    session[:comment_id] = @comment.id
    session[:comment_title] = @comment.title
    session[:comment_content] = @comment.content
    redirect_to :back
  end

  # GET /comments/delete
  def delete
    @comment.delete
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:comment_id])
    end
    def set_user
      if !session[:user_id].nil?
        @logged_user = User.find(session[:user_id])
      else
        redirect_to "/";
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    #def comment_params
    #  params[:comment]
    #end
end
