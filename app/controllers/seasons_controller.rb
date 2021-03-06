class SeasonsController < ApplicationController
  before_action :set_season, only: [:synch, :show, :edit, :update, :destroy]

  # GET /seasons
  # GET /seasons.json
  def index
    @seasons = Season.all
  end

  # GET /seasons/1
  def show
    respond_to do |format|  
        format.html { render action: 'show' }
    end
  end

  def synch 
    ser = Serie.where(id: @season.serie_id).take
    imdb = Imdb::Serie.new(ser.imdb_id)
    # puts imdb.season(ses.id.to_i).episodes.size
    @season.title = imdb.title.to_s
    @season.updated_at = Time.now
    @season.save

    respond_to do |format|
      if @season.nil?
        format.html { redirect_to :back, notice: 'Synch failed'}
      else
        format.html { render action: 'show'}
      end
    end
  end

  # POST /seasons/list_seasons
  def list_all_seasons
    @seasons = Season.where(serie_id: params[:id])

    respond_to do |format|
      if @seasons.nil?
        format.html { redirect_to :back, notice: 'There arent any seasons in the database.'}
      else
        format.html { render action: 'list_seasons'}
      end
    end
  end

  # GET /seasons/new
  def new
    @season = Season.new
  end

  # GET /seasons/1/edit
  def edit
  end

  # POST /seasons
  # POST /seasons.json
  def create
    @season = Season.new(season_params)

    respond_to do |format|
      if @season.save
        format.html { redirect_to @season, notice: 'Season was successfully created.' }
        format.json { render action: 'show', status: :created, location: @season }
      else
        format.html { render action: 'new' }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /seasons/1
  # PATCH/PUT /seasons/1.json
  def update
    respond_to do |format|
      if @season.update(season_params)
        format.html { redirect_to @season, notice: 'Season was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @season.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /seasons/1
  # DELETE /seasons/1.json
  def destroy
    @season.destroy
    respond_to do |format|
      format.html { redirect_to seasons_url }
      format.json { head :no_content }
    end
  end
  def set_seasons_torrent_link 
    t = TorrentApi.new
    Season.where(:torrent_link=>nil).each do |season|
      # season = Episode.find(1)
      serie_name = Serie.find(season.serie_id).title
      season_number = season.season
      if(season_number <= 0)
        next;
      else
        season_number = season_number.to_s
      end
      if(season_number.length < 2)
        season_number = '0'+season_number
      end
      t.search_term = "#{serie_name} Season #{season_number} Complete"
      found = t.search
      if(found.nil?)
        next;
      end 
      if(found.count > 0)
        link = found.first.link
      else
        next;
      end
      season.update(:torrent_link => link)
      season.update(:subs_link => "http://subsunacs.net/search.php?p=1&t=1&m=#{serie_name.gsub(" ","+")}")
    end
    redirect_to "/"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_season
      @season = Season.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def season_params
      params[:season]
    end
end
