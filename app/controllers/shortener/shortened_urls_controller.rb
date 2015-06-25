class Shortener::ShortenedUrlsController < ActionController::Base
  def show
    token = /^([#{Shortener.key_chars.join}]*).*/.match(params[:id])[1]
    sl = ::Shortener::ShortenedUrl.find_by_unique_key(token)

    if sl
      browser = Browser.new(:accept_language => request.headers["Accept-Language"],
                            :ua => request.headers["User-Agent"]
      )
      browser_id = browser.id
      platform_id = get_platform_id(browser)
      country_code_id = get_country_code_id(request)
      if request.referer.nil?
        referer_domain = 'unknown'
      else
        referer_domain = URI.parse(request.referer).host
      end

      shortened_url_browser = sl.shortened_url_browsers.where(:browser_name => browser_id).first_or_create()
      shortened_url_platform = sl.shortened_url_platforms.where(:platform => platform_id).first_or_create()
      shortened_url_country = sl.shortened_url_countries.where(:country_code => country_code_id).first_or_create()
      shortened_url_referer = sl.shortened_url_referers.where(:domain => referer_domain).first_or_create()

      shortened_url_log = Shortener::ShortenedUrlLog.new(:shortened_url_id => sl.id,
                                                         :browser => browser_id,
                                                         :platform => platform_id,
                                                         :country_code => country_code_id,
                                                         :referer_domain => referer_domain)
      shortened_url_log.save

      Thread.new do
        sl.increment!(:use_count)
        shortened_url_browser.increment!(:count)
        shortened_url_platform.increment!(:count)
        shortened_url_country.increment!(:count)
        shortened_url_referer.increment!(:count)
        ActiveRecord::Base.connection.close
      end
      redirect_to sl.url, :status => :moved_permanently
    else
      redirect_to '/'
    end
  end

  def get_platform_id(browser)
    case
      when browser.android?        then :android
      when browser.ios?            then :ios
      when browser.blackberry?     then :blackberry
      when browser.mac?            then :mac
      when browser.windows?        then :windows
      when browser.windows_mobile? then :windows_mobile
      when browser.windows_phone?  then :windows_phone
      when browser.linux?          then :linux
      when browser.chrome_os?      then :chrome_os
      else
        :other
    end
  end

  def get_country_code_id(request)
    info = GeoIP.new(Rails.root.join("lib/GeoIP.dat")).country(request.remote_ip)
    info.country_code2
  end
end