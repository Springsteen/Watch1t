class SeriesController < ApplicationController
  before_action :set_series, only: [:rewrite_serie,:show, :edit, :update, :destroy, :synch]
  before_action :set_user, only: [:rewrite_serial_db]

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

  def rewrite_serie
    new_serie = Imdb::Serie.new(@series.imdb_id)
    if new_serie.title.nil?
      redirect_to :back, notice: 'Serie was not successfully updated.'  
    else
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
          # epi.air_date = ses.episode(i.to_i).air_date.to_date
          epi.episode = e.episode.to_i
          epi.save
          i+=1
        end     
      end
      
      redirect_to :back, notice: 'Serie was successfully updated.'
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
    	if @series.nil? || @series.empty?
    		format.html {redirect_to :back, notice: "There arent any matches in the database !" }
      else
    		format.html {render "result"} 
    	end
    end
  end

  def rewrite_serial_db
    if(@logged_user.block_code != 8)
      redirect_to "/"
    end
    @all_serie = find_all_series()
    @all_serie.each do |imdb_serie_id|
      new_serie = Imdb::Serie.new(imdb_serie_id)
      if(new_serie.year != 0)
        created_serie = ""
        if(Serie.where(imdb_id:imdb_serie_id).take.nil?)
          created_serie = Serie.new(:title=>new_serie.title.to_s,:year=>new_serie.year.to_i,:description=>new_serie.plot.to_s,:imdb_id=>imdb_serie_id).save
        else
          created_serie = Serie.where(imdb_id:imdb_serie_id).take
        end
        new_serie.seasons.each do |imdb_season|
          crated_season = ""
          if(Season.where(season:imdb_season.season_number.to_i,serie_id:created_serie.id).take.nil?)
            created_season = Season.new(:serie_id=>created_serie.id,:season=>imdb_season.season_number.to_i).save
          else
            crated_season = Season.where(season:imdb_season.season_number.to_i,serie_id:created_serie.id).take
          end
          imdb_season.episodes.each_with_index do |episode,i=1|
            if(Episode.where(episode:episode.episode.to_i,season_id:crated_season.id).take.nil?)
              Episode.new(:episode=>episode.episode,:season_id=>crated_season.id,:title=>episode.title).save
            end
          end
        end
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
        format.html { redirect_to :back, notice: 'Serie was successfully updated.' }
      else
        format.html { redirect_to :back, notice: 'Serie was not successfully updated.' }
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
    def set_user
      if(!session[:user_id].nil?)
        @logged_user=User.find(session[:user_id])
      else
        redirect_to "/"
      end
    end
    def find_all_series()
      series = Array.new
      for i in 2012..2014
        Imdb::Search.new(i.to_s).movies().each do |movie|
          if(movie.title =~ /(TV Series)/) and (movie.year.to_i != 0)
            series << movie.id
          end
        end
      end
      return series.uniq{|x| x}
    end
end
