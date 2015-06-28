namespace :db_data do
  desc "Generates some test data with Forgery gem"
  task :generate => :environment do
    #my test user
    user = User.where(:email => "admin@devilmaydie.name").first

    browser_ids = [
        :edge,
        :ie,
        :chrome,
        :firefox,
        :android,
        :blackberry,
        :core_media,
        :ipad,
        :iphone,
        :ipod,
        :nintendo,
        :opera,
        :phantom_js,
        :psp,
        :playstation,
        :quicktime,
        :safari,
        :xbox,
        :other
    ]

    platforms = [
      :android,
      :ios,
      :blackberry,
      :mac,
      :windows,
      :windows_mobile,
      :windows_phone,
      :linux,
      :chrome_os
    ]

    shortened_url = Shortener::ShortenedUrl.new
    shortened_url.owner = user
    shortened_url.url = 'http://yandex.ru/'
    shortened_url.save

    500.times do |n|
      browser_id = browser_ids[rand(browser_ids.size)]
      platform_id = platforms[rand(platforms.size)]
      country_code_id = Faker::Address.country_code
      if rand(100) < 10
        referer_domain = 'unknown'
      else
        referer_domain = URI.parse(Faker::Internet.url).host
      end

      shortened_url_browser = shortened_url.shortened_url_browsers.where(:browser_name => browser_id).first_or_create()
      shortened_url_platform = shortened_url.shortened_url_platforms.where(:platform => platform_id).first_or_create()
      shortened_url_country = shortened_url.shortened_url_countries.where(:country_code => country_code_id).first_or_create()
      shortened_url_referer = shortened_url.shortened_url_referers.where(:domain => referer_domain).first_or_create()

      shortened_url_log = Shortener::ShortenedUrlLog.new(:shortened_url_id => shortened_url.id,
                                                         :browser => browser_id,
                                                         :platform => platform_id,
                                                         :country_code => country_code_id,
                                                         :referer_domain => referer_domain)
      shortened_url_log.created_at = Faker::Date.between(1000.days.ago, Date.today)
      shortened_url_log.save

      shortened_url.increment!(:use_count)
      shortened_url_browser.increment!(:count)
      shortened_url_platform.increment!(:count)
      shortened_url_country.increment!(:count)
      shortened_url_referer.increment!(:count)

    end
  end
end