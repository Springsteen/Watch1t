class CommentsController < ApplicationController
  before_action :set_comment,:set_user, only: [:post, :edit, :delete]

  # GET /comments/show
  def show
    serie_var = "2"
    epizode = "1"
    season = "1"
    @comments = Comment.where(serie: serie_var)
  end

  # POST /comments/post
  def post
    @comment = Comment.new(:user => @logged_user.user,:content => params[:comment],:title => params[:title],:epizode => "1",:season => "1",:serie => "2")
    if @comment.save
      flash[:notice_comment] = 'Comment was successfully created.';
      redirect_to "/comments/show"
    else
      flash[:notice_comment] = 'Problem';
      redirect_to "/comments/show"
    end
  end

  # POST comments/edit
  def edit
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /comments/delete
  def delete
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      #@comment = Comment.find(params[:id])
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
