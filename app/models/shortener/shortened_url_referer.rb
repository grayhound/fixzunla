class Shortener::ShortenedUrlReferer < ActiveRecord::Base
  belongs_to :shortened_url
end
