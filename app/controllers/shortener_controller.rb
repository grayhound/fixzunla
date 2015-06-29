class ShortenerController < ApplicationController
  BROWSER_NAMES = {
      edge: "Microsoft Edge",
      ie: "Internet Explorer",
      chrome: "Chrome",
      firefox: "Firefox",
      android: "Android",
      blackberry: "BlackBerry",
      core_media: "Apple CoreMedia",
      ipad: "iPad",
      iphone: "iPhone",
      ipod: "iPod Touch",
      nintendo: "Nintendo",
      opera: "Opera",
      phantom_js: "PhantomJS",
      psp: "PlayStation Portable",
      playstation: "PlayStation",
      quicktime: "QuickTime",
      safari: "Safari",
      xbox: "Xbox",
      other: "Other",
  }

  PLATFORM_NAMES = {
    android: "Android",
    ios: "IOS",
    blackberry: "Blackberry",
    mac: "Mac",
    windows: "Windows",
    windows_mobile: "Windows mobile",
    windows_phone: "Windows phone",
    linux: "Linux",
    chrome_os: "Chrome OS",
    other: "Other",
  }

  def new
    @shortener_url_object = Shortener::ShortenedUrl.new(shortener_shortened_url_params)
    @shortener_url_object.attributes = shortener_shortened_url_params
    @shortener_url_object.owner = current_user if user_signed_in?
    @is_valid = @shortener_url_object.save

    @shortened_url = shortener_show_url(:id => @shortener_url_object.unique_key) if @is_valid
    @shortener_url_object = Shortener::ShortenedUrl.new(shortener_shortened_url_params) if @is_valid

    respond_to do |format|
      format.html {
        render :partial => 'shortener/form', :locals => {
                                             :shortened_url_object => @shortener_url_object,
                                             :shortened_url => @shortened_url,
                                             :is_valid => @is_valid
                                           }
      }
    end
  end

  def list
    shortened_urls = current_user.shortened_urls.page(params[:page])
    respond_to do |format|
      format.html {
        render :partial => 'shortener/list', :locals => {:shortened_urls => shortened_urls}
      }
    end
  end

  def details
    #get shortened url
    @shortened_url = Shortener::ShortenedUrl.where(:unique_key => params[:unique_key]).first
    return render_404 if not @shortened_url
    return render_404 if not current_user
    return render_404 if not @shortened_url.owner == current_user

    #qr code for urls
    url = shortener_show_url(:id => @shortened_url.unique_key)
    @qr = RQRCode::QRCode.new(url, :size => 10, :level => :h)

    @clicks_chart = get_clicks_chart(@shortened_url)
    @referers_chart = get_referers_chart(@shortened_url)
    @browsers_chart = get_browsers_chart(@shortened_url)
    @countries_chart = get_countries_chart(@shortened_url)
    @platforms_chart = get_platforms_chart(@shortened_url)
  end

  def shortener_shortened_url_params
    params.require(:shortener_shortened_url).permit(:url)
  end

  def get_clicks_chart(shortened_url)
    data_table = ::GoogleVisualr::DataTable.new
    data_table.new_column("string", "Day")
    data_table.new_column("number", "Click count")

    data_raw = shortened_url.shortened_url_logs.
                         select('date(created_at) as day, count(id) as count').
                         where('date(created_at) > ?', 10.days.ago).
                         order('day').
                         group('day').to_a().
                         map { |value| {(value['day'].strftime('%d %b')) => value['count']}}.reduce(:merge)
    data = []
    ((Date.today-10)..Date.today).each do |date|
      day = date.strftime('%d %b')
      if not data_raw.nil? and data_raw.has_key?(day)
        data.push([day, data_raw[day]])
      else
        data.push([day, 0])
      end
    end
    data_table.add_rows(data)

    option = { width: 1000, height: 600, title: 'Daily clicks' }
    return ::GoogleVisualr::Interactive::LineChart.new(data_table, option)
  end

  def get_referers_chart(shortened_url)
    data_table = ::GoogleVisualr::DataTable.new
    data_table.new_column("string", "Domain")
    data_table.new_column("number", "Click count")

    data = shortened_url.shortened_url_referers.
                         order(:count => :desc, :updated_at => :desc).
                         limit(10).
                         select(:domain, :count).to_a().
                         map {|value| [value['domain'], value['count']]}
    data_table.add_rows(data)

    option = { width: 580, height: 580, title: 'Referers' }
    return ::GoogleVisualr::Interactive::PieChart.new(data_table, option)
  end

  def get_browsers_chart(shortened_url)
    data_table = ::GoogleVisualr::DataTable.new
    data_table.new_column("string", "Browser")
    data_table.new_column("number", "Click count")

    data = shortened_url.shortened_url_browsers.
        order(:count => :desc, :updated_at => :desc).
        select(:browser_name, :count).to_a().
        map {|value| [BROWSER_NAMES[value['browser_name'].to_sym()], value['count']]}
    data_table.add_rows(data)

    option = { width: 580, height: 580, title: 'Browsers' }
    return ::GoogleVisualr::Interactive::BarChart.new(data_table, option)
  end

  def get_countries_chart(shortened_url)
    data_table = ::GoogleVisualr::DataTable.new
    data_table.new_column("string", "Country")
    data_table.new_column("number", "Click count")

    data = shortened_url.shortened_url_countries.
        order(:count => :desc, :updated_at => :desc).
        select(:country_code, :count).
        where('country_code != ?', '--').to_a().
        map {|value| [Country[value['country_code']].name, value['count']]}
    data_table.add_rows(data)

    option = { width: 580, height: 580, title: 'Countries' }
    return ::GoogleVisualr::Interactive::GeoChart.new(data_table, option)
  end

  def get_platforms_chart(shortened_url)
    data_table = ::GoogleVisualr::DataTable.new
    data_table.new_column("string", "Platform")
    data_table.new_column("number", "Click count")

    data = shortened_url.shortened_url_platforms.
        order(:count => :desc, :updated_at => :desc).
        select(:platform, :count).to_a().
        map {|value| [PLATFORM_NAMES[value['platform'].to_sym()], value['count']]}
    data_table.add_rows(data)

    option = { width: 580, height: 580, title: 'Platforms' }
    return ::GoogleVisualr::Interactive::BarChart.new(data_table, option)
  end

end
