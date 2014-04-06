class SeriesController < ApplicationController
  before_action :set_series, only: [:rewrite_serial_db, :show, :edit, :update, :destroy, :synch]

  # GET /series
  # GET /series.json
  def index
    @series = Serie.all
  end

  # GET /series/1
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

  def rewrite_serial_db
    new_serie = Imdb::Serie.new(@series.imdb_id)
    @series[:title] = new_serie.title.to_s
    @series[:year] = new_serie.year.to_i
    @series[:description] = new_serie.plot.to_s
    @series[:updated_at] = Time.now
    @series.save

    Season.where(serie_id: @series.id).each do |s|
      Episode.where(season_id: s.id).each do |e|
        e.delete
      end
      s.delete  
    end
    

    new_serie.seasons.each do |ses|
      s = Season.new
      s.serie_id = @series.id
      s.season = ses.season_number.to_i
      s.save

      
      i=1
      ses.episodes.each do |e|
        epi = Episode.new
        epi.season_id = s.id
        epi.title = ses.episode(i.to_i).title.to_s
       # epi.air_date = DateTime.parse(ses.episode(i.to_i).air_date)
        epi.episode = e.episode.to_i
        epi.save
        i+=1
      end     
    end

    respond_to do |format|
      if !@series.nil?
        format.html { redirect_to @series, notice: 'Serie was successfully updated.' }
      else
        format.html { redirect_to series_url, notice: 'Serie was not successfully updated.' }
      end
    end
  end
  # PATCH/PUT /series/1
  def synch
    new_serie = Imdb::Serie.new(@series.imdb_id)
    @series[:title] = new_serie.title.to_s
    @series[:year] = new_serie.year.to_i
    @series[:description] = new_serie.plot.to_s
    @series[:updated_at] = Time.now
    @series.save

    respond_to do |format|
      if !@series.nil?
        format.html { redirect_to @series, notice: 'Serie was successfully updated.' }
      else
        format.html { redirect_to series_url, notice: 'Serie was not successfully updated.' }
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
