require "collage/version"
require "collage/cli"
require 'services/flickr_service'
require 'services/keyword_generator_service'
require 'helpers/image_handler'
require 'helpers/collage_factory'

module EtventureCollageMaker
  @flickr = FlickrService.instance
  @keyword_generator = KeywordGeneratorService.instance
  @log = Logging.logger['EtventureCollageMaker']

  def self.create(opts = {})
    images = []

    @log.info("Starting query keywords on Flickr")
    opts[:keywords].each do |keyword|
      image_url = @flickr.get_photo_by_keyword(keyword)
      images << image_url unless image_url.nil?
    end

    # Complete 10 images by quering Flickr random keywords
    while images.length < 10 do
      random_keyword = @keyword_generator.next_keyword

      @log.warn("Using random keyword: \"#{random_keyword}\"")

      image_url = @flickr.get_photo_by_keyword(random_keyword)
      images << image_url unless image_url.nil?
    end

    # Download images
    local_images = []
    images.each do |image|
      local_images << ImageHandler.download(image)
    end

    # Generate collage
    CollageFactory.build({
      width:  opts[:width],
      height: opts[:height],
      images: local_images,
      output: opts[:output]
    })

    # Cleanup
    local_images.each do |local_image|
      ImageHandler.clean(local_image)
    end

    @log.info("Done!")

    true
  end
end
