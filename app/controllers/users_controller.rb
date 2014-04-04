class UsersController < ApplicationController
  before_action :set_user
  @logged_user
  require 'digest/md5'
  #POST /user/login
  def login
      if params[:user].blank? || params[:password].blank?
        flash[:user_panel_notice] = "Don't tuch my HTML code"
        redirect_to :back
      elsif User.where(user: params[:user],password: Digest::MD5.hexdigest(params[:password])).take.nil?
        flash[:user_panel_notice] = "Wrong User or password"
        redirect_to :back
      else
        session[:user_id] = User.where(user: params[:user]).take.id
        set_user()
        if @logged_user.ip != request.remote_ip
          UserMailer.email(@logged_user.email,"Watch1t Team","Computer with IP "+request.remote_ip+" logged in your account.").deliver
          @logged_user.update(:ip => request.remote_ip)
        end
        if @logged_user.email_check != '1'
          flash[:user_panel_notice] = "Please validate your E-Mail."
          redirect_to :back
        else
          redirect_to :back
        end
      end
  end
  
  
  #GET /user/logout
  def logout
    session[:user_id] = nil;
      redirect_to "/users"
  end

  def validate_email
      if params[:validate_mail_code].blank?
        flash[:user_panel_notice] = "Please Validate your E-Mail."
        redirect_to :back
      elsif @logged_user.email_check != params[:validate_mail_code]
        flash[:user_panel_notice] = "Wrong Validate code."
        redirect_to :back
      else
        @logged_user.update(:email_check => (1).to_s);
        redirect_to :back
      end
  end
  
  # POST /users/create
  def create
    respond_to do |format|
      if params[:user].blank? || params[:password].blank? || params[:email].blank? || params[:secret_answer].blank? || params[:secret_question].blank?
         format.html { redirect_to :back, notice: 'Problem'}
      elsif !User.where(user: params[:user]).take.nil?
        format.html { redirect_to :back, notice: 'This user already exist.'}
      elsif session[:code] != params[:check_code]
        format.html { redirect_to :back, notice: 'Wrong Code.'}
      elsif params[:repeat_password] != params[:password]
        format.html { redirect_to :back, notice: 'Wrong Repeat Password.'}
      elsif !User.where(email: params[:email]).take.nil?
        format.html { redirect_to :back, notice: 'This email already exist.'}
      else
        check_mail_code = Digest::MD5.hexdigest((Time.now.to_i + Random.rand(5000-10)).to_s)
        @user = User.new(:country => params[:country],:skype => params[:skype],:user => params[:user],:password => Digest::MD5.hexdigest(params[:password]),:block_code => 1,:email => params[:email],:email_check => check_mail_code,:secret_question => params[:secret_question],:secret_answer => params[:secret_answer],:ip => request.remote_ip)
        if @user.save
          UserMailer.email(User.where(user: params[:user]).take.email,"Watch1t Team","Validate Mail Code: "+check_mail_code).deliver
          format.html { redirect_to :back, notice: 'Your account was successfully created.' }
          session.delete(:code)
        else
          format.html { redirect_to :back, notice: 'System Problem' }
          session.delete(:code)
        end
      end
     end
  end
  
  # POST users/update
  def update
    respond_to do |format|
      if @logged_user.password == params[:edit_password]
        password = @logged_user.password
      else
        password = Digest::MD5.hexdigest(params[:edit_password])
      end
      if params[:user].blank? || params[:edit_password].blank? || params[:email].blank? || params[:secret_answer].blank? || params[:secret_question].blank?
         format.html { redirect_to :back, notice: 'Problem'}
      elsif params[:repeat_password] != params[:edit_password]
        format.html { redirect_to :back, notice: 'Wrong Repeat Password.'}
      elsif User.where(user: params[:user]).count >= 1 && @logged_user.user != params[:user]
        format.html { redirect_to :back, notice: 'This user already exist.'}
        check_mail_code = Digest::MD5.hexdigest(Time.now.to_i + Random.rand(5000-10));
        UserMailer.email(User.where(user: params[:user]).take.email,"Watch1t Team","Validate Mail Code: "+  check_mail_code).deliver
      elsif @logged_user.update(:user => params[:user],:password => password,:email => params[:email],:secret_question => params[:secret_question],:secret_answer => params[:secret_answer],:country => params[:country],:skype => params[:skype])
        format.html { redirect_to :back, notice: 'Your account was successfully updated.' }
      else
        format.html { redirect_to :back, notice: 'System Problem.' }
      end
    end
  end
  
  # GET users/destroy
  def destroy
    session[:user_id] = nil;
    respond_to do |format|
      format.html { redirect_to :back, user_panel_notice: "Your account was successfully deleted." }
    end
  end
   
  # POST users/contacts
  def contacts
    if !(User.where(:block_code => 8).pluck(:email).include?(params[:admin_email]))
      flash[:contacts] = "Toq Email ne e na admin"
      redirect_to :back
    elsif(params[:user_email])
      flash[:contacts] = "Nqma user email"
      redirect_to :back 
    elsif(params[:email_content].nil?)
      flash[:contacts] = "Nqma content"
      redirect_to :back
    else
      UserMailer.email(params[:admin_email],"User Question: "+params[:email_subject],params[:email_content]).deliver
      flash[:contacts] = "OK"
      redirect_to :back
    end
  end
  def search_torents
   update_links()
  end
  private
    def update_links()
      episodes = Episode.where(torrent_link:nil)
      episodes.each do |e|
        serie_air_date = e.air_date.to_s.gsub('-', '').to_i
        time_now = Time.now.to_s.split(' ')[0].gsub('-', '').to_i
        if(time_now > serie_air_date)
          serial_name = Serie.find(Season.find(e.season_id).serie_id).title
          season = Season.find(e.season_id).season
          episode = e.episode
          @result = get_links(serial_name,season,episode)
          Episode.find(e.id).update(:torrent_link => @result[0],:subs_link => @result[1])
        end
      end
    end 
    def get_links(serie,season,episode)
      website="http://zamunda.net/"
      found = {'torrent_link'=>Array.new,'subs' => Array.new}
      page_counter = 0;
      begin
        next_page = "http://zamunda.net/browse.php?c33=1&c7=1&search="+serie+"&incldead=1&field=name&page="+page_counter.to_s
        agent = Mechanize.new
        zamunda = agent.get(next_page)
        login = zamunda.form_with(:action => "takelogin.php")
        login.field_with(:name => "username").value = "watch1tteam"
        login.field_with(:name => "password").value = "PowerPassword1"
        zamunda_body = login.submit.body
        nokogiri_doc = Nokogiri::HTML(zamunda_body)
        nokogiri_doc.css("table.test>tr:not(:first-child)>td[align=\"left\"]").each do |row|
          subs = Nokogiri::HTML(row.to_s).css("a+img")
          if(subs.to_s =~ /(subtitles|субтитри)/)
            subs = website+Nokogiri::HTML(row.to_s).css("a:first-child").first.attr('href')
          elsif(subs.to_s =~ /(audio|озвучение)/)
            subs = "with bg audio"
          else
            subs = nil
          end
          found['torrent_link'] << website+Nokogiri::HTML(row.to_s).css("a:nth-child(2n)").first.attr('href')
          found['subs'] << subs
        end
        page_counter += 1
      end while(found['torrent_link'].count >= page_counter*20)
      torrent_links = get_torrent_links(found['torrent_link'],serie,season,episode)
      if(!torrent_links.empty?)
        film_number = get_film_number_with_subs(found['subs'],torrent_links)
        if(!film_number.nil?)
          if(found['subs'][film_number] != "with bg audio")
            subs_link = get_subs_link(found['subs'][film_number]) 
          end
        else
          subs_link = nil
          film_number = torrent_links[0]
        end
        torrent_link = found['torrent_link'][film_number]
      else
        torrent_link = nil
        subs_link = nil
      end
      return [torrent_link,subs_link]
    end
    def get_torrent_links(torrent_links,serie,season,episode=nil)
      links = Array.new()
      torrent_links.each_with_index do |link,counter|
          if(link.downcase =~ /(season|s)(0|\s|)#{season}/) && (link.downcase =~ /(episode|e)(0|00|\s|)#{episode}/ || episode.nil?)
            if(link.downcase =~ /(720p|1080p)/)
              links.insert(0,counter)
            else
              links << counter
            end
          end
      end 
      return links
    end
    def get_film_number_with_subs(subs_links,torrent_links_numbers)
      found_subs_number = nil  
      torrent_links_numbers.each do |number|
        if(!subs_links[number].nil?)
          found_subs_number = number
          break
        end
      end 
      return found_subs_number
    end
    def get_subs_link(serie_page)
      agent = Mechanize.new
      zamunda = agent.get(serie_page)
      login = zamunda.form_with(:action => "takelogin.php")
      login.field_with(:name => "username").value = "watch1tteam"
      login.field_with(:name => "password").value = "PowerPassword1"
      zamunda_body = login.submit.body
      nokogiri_doc = Nokogiri::HTML(zamunda_body)
      return nokogiri_doc.css("table.mainouter table.test div[align=\"center\"] td.bottom>a:last-child").last.attr('href')
    end
    def set_user
      #session[:user_id] = nil
      if !session[:user_id].nil?
       session[:user_id] = session[:user_id]
       @logged_user=User.find(session[:user_id])
      else
        @logged_user = nil;
      end
    end
end
