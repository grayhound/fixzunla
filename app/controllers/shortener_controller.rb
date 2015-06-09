class ShortenerController < ApplicationController
  def new
    @shortener_url_object = Shortener::ShortenedUrl.new(shortener_shortened_url_params)
    @shortener_url_object.attributes = shortener_shortened_url_params
    @is_valid = @shortener_url_object.save
    @shortened_url = shortener_show_url(:id => @shortener_url_object.unique_key) if @is_valid
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

  def shortener_shortened_url_params
    params.require(:shortener_shortened_url).permit(:url)
  end
end
