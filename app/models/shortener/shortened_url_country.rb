class Shortener::ShortenedUrlCountry < ActiveRecord::Base
  belongs_to :shortened_url
end
