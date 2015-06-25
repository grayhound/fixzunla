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
      shortened_url_browser = sl.shortened_url_browsers.where(:browser_name => browser_id).first_or_create()
      shortened_url_platform = sl.shortened_url_platforms.where(:platform => platform_id).first_or_create()
      Thread.new do
        sl.increment!(:use_count)
        shortened_url_browser.increment!(:count)
        shortened_url_platform.increment!(:count)
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
end