class Shortener::ShortenedUrlPlatform < ActiveRecord::Base
  belongs_to :shortened_url
end
