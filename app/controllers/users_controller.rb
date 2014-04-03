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
    
    #find_torents.delay(run_at: 5.minutes.from_now)
  end
  private
    def find_links
      episodes = Episode.where(torrent_link:nil)
      episodes.each do |e|
        serie_air_date = e.air_date.to_s.gsub('-', '').to_i
        time_now = Time.now.to_s.split(' ')[0].gsub('-', '').to_i
        if(time_now > serie_air_date)
          serial_name = Serie.find(Season.find(e.season_id).serie_id).title
          season = Season.find(e.season_id).season
          episode = e.episode
          @result = search_torent(serial_name,season,episode)
          Episode.update(:torrent_link => @result[0],:subs_link => @result[1])
        end
      end
    end 
    def search_torent(serie,season,episode=nil)
      subs = nil
      found_torrent = nil
      found = {'film_link'=>Array.new,'torrent_link'=>Array.new,'subs' => Array.new}
      page_counter = 0;
      array_counter = 0;
      begin
        next_page = "http://zamunda.net/browse.php?c33=1&c7=1&search="+serie+"&incldead=1&field=name&page="+page_counter.to_s
        agent = Mechanize.new
        zamunda = agent.get(next_page)
        login = zamunda.form_with(:action => "takelogin.php")
        login.field_with(:name => "username").value = "watch1tteam"
        login.field_with(:name => "password").value = "PowerPassword1"
        result = login.submit
        zamunda_body = result.body
        nokogiri_doc = Nokogiri::HTML(zamunda_body)
        found['subs'][array_counter] = nokogiri_doc.css("table.test>tr:not(:first-child)>td[align=\"left\"]>a+img")
        found['film_link'][array_counter] = nokogiri_doc.css("table.test>tr:not(:first-child)>td[align=\"left\"]>a:first-child")
        found['torrent_link'][array_counter] = nokogiri_doc.css("table.test>tr:not(:first-child)>td[align=\"left\"]>a:nth-child(2n)")
        page_counter +=1
        array_counter += 1
      end while(found['torrent_link'][array_counter-1].count >= 20)
      first_found_torrent = "";
      first_subs = nil;
      found['torrent_link'].each_with_index do |page_series,page_counter|
        page_series.each_with_index do |serie_torrent,link_counter|
         check_subs = 0
         serie_torrent_with_downcase = serie_torrent.attr('href').downcase
         if(serie_torrent_with_downcase =~ /.(season|s)(\d|\s)#{season}/)
           if((!found['subs'][page_counter][link_counter].nil?))
             if(found['subs'][page_counter][link_counter].attr('title') =~ /.(subtitles|субтитри)/)
               check_subs = found['film_link'][page_counter][link_counter].attr('href') #with bg subtitles
               agent = Mechanize.new
               zamunda = agent.get("http://zamunda.net/"+check_subs)
               login = zamunda.form_with(:action => "takelogin.php")
               login.field_with(:name => "username").value = "watch1tteam"
               login.field_with(:name => "password").value = "PowerPassword1"
               result = login.submit
               zamunda_body = result.body
               nokogiri_doc = Nokogiri::HTML(zamunda_body)
               check_subs = nokogiri_doc.css("table.mainouter table.test div[align=\"center\"] td.bottom>a:last-child")
             elsif(found['subs'][page_counter][link_counter].attr('title') =~ /.(audio|озвучение)/)
               check_subs = 2 #with bg audio    
             else
               check_subs = 0 #without subs 
             end
           end
           if ((serie_torrent_with_downcase =~ /.(episode|e)(\d|\s(\d|)|)#{episode}/) ||
           ((!(serie_torrent_with_downcase =~ /(episode|e)\d/)) && episode.nil?))
             if  ((page_counter == 0 && link_counter == 0 && check_subs != 0) || 
                   (first_found_torrent.nil? && 
                     page_counter == (found['torrent_link'].count -1 ) &&
                     link_counter == (page_series.count -1 )
                   )
                 )
               first_found_torrent = serie_torrent.attr('href')
               first_subs = check_subs
             end
             if(serie_torrent_with_downcase =~ /.(hdtv|720p)./)
               found_torrent = serie_torrent.attr('href')
               subs = check_subs
               break
             end
           end
         end    
        end
      end
      if(found_torrent.nil?)
        found_torrent = first_found_torrent
        subs = first_subs
      end
      if(subs != 0 && subs != 2)
       
      end
      return [found_torrent,subs]
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
