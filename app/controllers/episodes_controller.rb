class EpisodesController < ApplicationController
  before_action :set_episode, only: [:synch_air_date, :show, :edit, :update, :destroy]

  # GET /episodes
  # GET /episodes.json
  def index
    @episodes = Episode.all
  end

  # GET /episodes/1
  # GET /episodes/1.json
  def show
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

  private
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
