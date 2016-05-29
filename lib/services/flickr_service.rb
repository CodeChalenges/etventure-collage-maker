require 'singleton'
require 'flickraw'

class FlickrService
  include Singleton

  def initialize
    FlickRaw.api_key = ENV['FLICKR_API_KEY']
    FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET']
    @flickr_client = FlickRaw::Flickr.new
    @log = Logging.logger['FlickrService']
  end

  def get_photo_by_keyword(keyword = nil)
    return nil if (keyword.nil? or keyword.empty?)

    # Search the first photo matching the keyword
    photo = @flickr_client.photos.search(text: keyword, sort: :relevance).first

    # No photo found for the given keyword
    if photo.nil?
      @log.warn("No photo match the keyword: \"#{keyword}\"")
      return nil
    end

    # Fetch image information
    img_info = @flickr_client.photos.getInfo(photo_id: photo.id, secret: photo.secret)

    # Get image public URL
    img_url = FlickRaw.url_c(img_info)

    @log.info("Photo found - Keyword: \"#{keyword}\", Photo URL: \"#{img_url}\"")

    img_url
  end
end
