class Shortener::ShortenedUrlLog < ActiveRecord::Base
  belongs_to :shortened_url
end
