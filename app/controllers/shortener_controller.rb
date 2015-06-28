class ShortenerController < ApplicationController
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
    @qr = RQRCode::QRCode.new(url, :size => 4, :level => :h)

    @referers_chart = get_referers_chart(@shortened_url)
  end

  def shortener_shortened_url_params
    params.require(:shortener_shortened_url).permit(:url)
  end

  def get_referers_chart(shortened_url)
    referers_table = ::GoogleVisualr::DataTable.new
    referers_table.new_column("string", "domain")
    referers_table.new_column("number", "count")

    data = shortened_url.shortened_url_referers.
                         order(:count => :desc, :updated_at => :desc).
                         limit(10).
                         select(:domain, :count).to_a().
                         map {|value| [value['domain'], value['count']]}
    referers_table.add_rows(data)

    option = { width: 580, height: 360, title: 'Referers' }
    return ::GoogleVisualr::Interactive::PieChart.new(referers_table, option)
  end

end
