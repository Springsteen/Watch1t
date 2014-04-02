class SeriesController < ApplicationController
  before_action :set_series, only: [:show, :edit, :update, :destroy]

  # GET /series
  # GET /series.json
  def index
    @series = Serie.all
  end

  # GET /series/1
  # GET /series/1.json
  def show
    respond_to do |format|
      if @series.nil?
        format.html {redirect_to :back, notice: "There isnt any serie with that id !" }
      else
        format.html {render "show"} 
      end
    end
  end

  # GET /series/new
  def new
    @series = Serie.new
  end

  # GET /series/1/edit
  def edit
  end

  # POST /series/search
  def search
    @series = Serie.search params[:search]
    respond_to do |format|
    	if @series.empty?
    		format.html {redirect_to :back, notice: "There arent any matches in the database !" }
      else
    		format.html {render "result"} 
    	end
    end
  end

  # PATCH/PUT /series/1
  def synch
    s = @series.first
    new_serie = Imdb::Serie.new(s.imdb_id)

    s[:title] = new_serie.title.to_s
    s[:year] = new_serie.year.to_i
    s[:updated_at] = Time.now
    s.save

    respond_to do |format|
      if !@series.empty?
        format.html { redirect_to @series, notice: 'Serie was successfully updated.' }
      else
        format.html { redirect_to series_url }
      end
    end
  end

  # DELETE /series/1
  # DELETE /series/1.json
  def destroy
    @series.destroy
    respond_to do |format|
      format.html { redirect_to series_url }
      format.json { head :no_content }
    end
  end

private
    # Use callbacks to share common setup or constraints between actions.
    def set_series
      @series = Serie.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def series_params
      params[:series]
    end
end
