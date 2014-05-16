class EpisodesController < ApplicationController
  before_action :set_episode, only: [:find_video, :synch_air_date, :show, :edit, :update, :destroy]
@link
  # GET /episodes
  # GET /episodes.json
  def index
    @episodes = Episode.all
  end

  # GET /episodes/1
  # GET /episodes/1.json
  def show
  end

  def find_video
    search = VideoSearch.new
    @link = "http://www.youtube.com/embed/"
    @link += search.find (parse_info (@episode))
    respond_to do |format|
      if @episode.nil?
        format.html { redirect_to :back, notice: 'Problem.' }
      else
        format.html { render action: 'show_video' }
      end
    end
  end

  def list_all_episodes
    @episodes = Episode.where(season_id: params[:id])
    respond_to do |format|
      if @episodes.nil?
        format.html { redirect_to :back, notice: 'There arent any episodes in the database.' }
      else
        format.html { render action: 'list_episodes' }
      end
    end
  end

  def synch_air_date 
    ses = Season.where(id: @episode.season_id).take
    ser = Serie.where(id: ses.serie_id).take
    imdb = Imdb::Serie.new(ser.imdb_id)
    # puts imdb.season(ses.id.to_i).episodes.size
    @episode.air_date = DateTime.parse(imdb.season(ses.season.to_i).episode(@episode.episode).air_date)
    @episode.save

    respond_to do |format|
      if @episode.nil?
        format.html { redirect_to :back, notice: 'Synch failed.' }
      else
        format.html { render action: 'show' }
      end
    end
  end

  # GET /episodes/new
  def new
    @episode = Episode.new
  end

  # GET /episodes/1/edit
  def edit
  end

  # POST /episodes
  # POST /episodes.json
  def create
    @episode = Episode.new(episode_params)

    respond_to do |format|
      if @episode.save
        format.html { redirect_to @episode, notice: 'Episode was successfully created.' }
        format.json { render action: 'show', status: :created, location: @episode }
      else
        format.html { render action: 'new' }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /episodes/1
  # PATCH/PUT /episodes/1.json
  def update
    respond_to do |format|
      if @episode.update(episode_params)
        format.html { redirect_to @episode, notice: 'Episode was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @episode.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /episodes/1
  # DELETE /episodes/1.json
  def destroy
    @episode.destroy
    respond_to do |format|
      format.html { redirect_to episodes_url }
      format.json { head :no_content }
    end
  end
  def set_episode_torrent_link
    t = TorrentApi.new
    Episode.where(:torrent_link=>nil).each do |episode|
      # episode = Episode.find(1)
      serie_name = Serie.find(Season.find(episode.season_id).serie_id).title
      episode_season = Season.find(episode.season_id).season
      episode_number = episode.episode
      if(episode_season <= 0)
        next;
      else
        episode_season = episode_season.to_s
      end
      
      if(episode_number <= 0)
        next;
      else
        episode_number = episode_number.to_s
      end
      
      if(episode_season.length < 2)
        episode_season = '0'+episode_season
      end
      if(episode_number.length < 2)
        episode_number = '0'+episode_number
      end
      t.search_term = "#{serie_name} S#{episode_season}E#{episode_number}"
      found = t.search
      if(found.nil?)
        next;
      end 
      if(found.count > 0)
        link = found.first.link
      else
        next;
      end
      episode.update(:torrent_link => link)
      episode.update(:subs_link => "http://subsunacs.net/search.php?p=1&t=1&m=#{serie_name.gsub(" ","+")}")
    end
    redirect_to "/"
  end
  private
    def parse_info e
      ses = Season.where(id: e.season_id).take
      ser = Serie.where(id: ses.serie_id).take
      imdb = Imdb::Serie.new(ser.imdb_id)
      output = String.new
      output += ser.title.gsub!("\"","")
      output += " "
      
      if ses.season < 10 
        output += "S0"
        output += ses.season.to_s
      else
        output += ses.season.to_s
      end
      
      output += " "

      if e.episode < 10 
        output += "E0"
        output += e.episode.to_s
      else
        output += ses.season.to_s
      end

      return output
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_episode
      @episode = Episode.find(params[:id])
      @epis = Episode.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def episode_params
      params[:episode]
    end
end
