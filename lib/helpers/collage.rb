require 'rmagick'

module Collage
  include Magick

  def self.build(args = {})
    raise(ArgumentError, "No image provided") if (args[:images].nil? or args[:images].empty?)

    props = {
      width:  args[:width]  || 1024,
      height: args[:height] || 768,
      images: args[:images],
      output: args[:output] || "output.jpg",
      tile_h: (args[:images].length / 2.0).ceil,
      tile_v: 2
    }

    image_list = ImageList.new

    # Build images and put in list
    props[:images].each do |image|
      image_list << Image.read(image).first
    end

    # Calculate images positions
    padding = {}
    padding[:x] = props[:width]  * 0.01
    padding[:y] = props[:height] * 0.01

    image_dim = {}
    image_dim[:width]  = (props[:width]  - 6 * padding[:x]) / props[:tile_h]
    image_dim[:height] = (props[:height] - 6 * padding[:y]) / props[:tile_v]

    # Create montage
    image_list = image_list.montage do
      self.tile = "#{props[:tile_h]}x#{props[:tile_v]}"
      self.background_color = "#ffffff"
      self.geometry = "#{image_dim[:width]}x#{image_dim[:height]}+#{padding[:x]}+#{padding[:y]}"
      self.shadow = true
    end

    # Flatten images and write to output file
    collage = image_list.flatten_images
    collage.resize!(props[:width], props[:height])
    collage.write(props[:output])

    true
  end
end
