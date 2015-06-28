Shortener::ShortenedUrl.class_eval do
  has_many :shortened_url_browsers
  has_many :shortened_url_platforms
  has_many :shortened_url_countries
  has_many :shortened_url_referers
  has_many :shortened_url_logs
end