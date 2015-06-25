class Shortener::ShortenedUrlBrowser < ActiveRecord::Base
  belongs_to :shortened_url
end
