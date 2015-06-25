Shortener::ShortenedUrl.class_eval do
  has_many :shortened_url_browsers
  has_many :shortened_url_platforms
end