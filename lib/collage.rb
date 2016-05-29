require "collage/version"
require 'services/flickr_service'
require 'services/keyword_generator_service'
require 'helpers/image_handler'
require 'helpers/collage'

module Collage
  @flickr = FlickrService.instance
  @keyword_generator = KeywordGeneratorService.instance

  def self.create(keywords = [])
    images = []

    keywords.each do |keyword|
      image_url = @flickr.get_photo_by_keyword(keyword)
      images << image_url unless image_url.nil?
    end

    # Complete 10 images by quering Flickr random keywords
    while images.length < 10 do
      random_keyword = @keyword_generator.next_keyword
      image_url = @flickr.get_photo_by_keyword(random_keyword)
      images << image_url unless image_url.nil?
    end

    # Download images
    local_images = []
    images.each do |image|
      local_images << ImageHandler.download(image)
    end

    # Generate collage
    Collage.build({images: local_images})

    # Cleanup
    local_images.each do |local_image|
      ImageHandler.clean(local_image)
    end

    true
  end
end
