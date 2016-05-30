require 'rmagick'
require 'logging'

module CollageFactory
  include Magick

  @log = Logging.logger['CollageFactory']

  def self.build(args = {})
    raise(ArgumentError, "No image provided") if (args[:images].nil? or args[:images].empty?)

    # Define collage general properties
    props = build_props(args)

    # Define image list (basic structure to create a montage)
    image_list = build_image_list(props[:images])

    # Montage specific attributes
    montage_props = build_montage_props(props)

    @log.debug("Starting collage - props: #{props}")

    # Create montage
    @log.info("Creating collage...")
    montage = image_list.montage do
      self.font =             montage_props[:font]
      self.tile =             montage_props[:tile]
      self.background_color = montage_props[:background_color]
      self.geometry =         montage_props[:geometry]
      self.shadow =           montage_props[:shadow]
    end
    @log.info("Collage done!")

    # Flatten images and write to output file
    collage = montage.flatten_images
    collage.resize!(props[:width], props[:height])
    collage.write(props[:output])

    return collage
  end

  def self.build_props(args)
    {
      width:  args[:width].nil?  ? 1024 : args[:width].to_i,
      height: args[:height].nil? ? 768  : args[:height].to_i,
      images: args[:images],
      output: args[:output] || "output.jpg",
      tile_h: (args[:images].length / 2.0).ceil,
      tile_v: 2
    }
  end

  def self.build_image_list(images_url)
    image_list = ImageList.new

    # Build images and put in list
    images_url.each do |image|
      image_list << Image.read(image).first
    end

    image_list
  end

  def self.build_montage_props(props)
    # Calculate images positions
    padding = {}
    padding[:x] = props[:width]  * 0.01
    padding[:y] = props[:height] * 0.01

    image_dim = {}
    image_dim[:width]  = (props[:width]  - 6 * padding[:x]) / props[:tile_h]
    image_dim[:height] = (props[:height] - 6 * padding[:y]) / props[:tile_v]

    {
      font:             ENV['IMAGEMAGICK_FONT'] || 'DejaVu-Sans',
      tile:             "#{props[:tile_h]}x#{props[:tile_v]}",
      background_color: "#ffffff",
      geometry:         "#{image_dim[:width]}x#{image_dim[:height]}+#{padding[:x]}+#{padding[:y]}",
      shadow:           true
    }
  end

  private_class_method :build_props, :build_image_list, :build_montage_props
end
