require 'singleton'
require 'flickraw'

class FlickrService
  include Singleton

  def initialize
    FlickRaw.api_key = ENV['FLICKR_API_KEY']
    FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET']
    @flickr_client = FlickRaw::Flickr.new
  end

  def get_photo_by_keyword(keyword = nil)
    return nil if (keyword.nil? or keyword.empty?)

    # Search the first photo matching the keyword
    photo = @flickr_client.photos.search(text: keyword).first

    # No photo found for the given keyword
    return nil if photo.nil?

    # Fetch image information
    img_info = @flickr_client.photos.getInfo(photo_id: photo.id, secret: photo.secret)

    # Get image public URL
    img_url = FlickRaw.url_o(img_info)

    img_url
  end
end
