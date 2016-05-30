require 'rmagick'
require "spec_helper"
require "helpers/collage_factory"

RSpec.describe CollageFactory do
  let(:images) {
    [
      "spec/fixtures/images/dog1.jpg",
      "spec/fixtures/images/dog2.jpg",
      "spec/fixtures/images/dog3.jpg"
    ]
  }
  let(:arguments) {
    {
      width:  1024,
      height: 768,
      output: "output.jpg",
      images: images
    }
  }

  # Collage cleanup
  after { File.delete(arguments[:output]) if File.exist?(arguments[:output]) }

  describe 'build' do
    context 'build collage' do
      subject { CollageFactory.build(arguments) }

      it { is_expected.to_not be_nil }
      it { is_expected.to be_a(Magick::Image) }
    end

    context "empty image list" do
      before { arguments[:images] = [] }
      it { expect{CollageFactory.build(arguments)}.to raise_error(ArgumentError) }
    end

    context "nil image list" do
      before { arguments[:images] = nil }
      it { expect{CollageFactory.build(arguments)}.to raise_error(ArgumentError) }
    end
  end

  describe 'build_props' do
    let(:props) { CollageFactory.send(:build_props, arguments) }

    it 'should build correct properties' do
      expect(props[:width]).to  eq(arguments[:width])
      expect(props[:height]).to eq(arguments[:height])
      expect(props[:width]).to  eq(arguments[:width])
      expect(props[:images]).to eq(arguments[:images])
      expect(props[:tile_h]).to eq((arguments[:images].length / 2.0).ceil)
      expect(props[:tile_v]).to eq(2)
    end
  end

  describe 'build_image_list' do
    let(:image_list) { CollageFactory.send(:build_image_list, images) }

    it 'should have all images' do
      expect(image_list.length).to eq(images.length)
    end

    it 'should have all URLs converted to Image' do
      image_list.each do |image|
        expect(image).to be_a(Magick::Image)
        expect(images.include?(image.filename)).to be true
      end
    end
  end

  describe 'build_montage_props' do
    let(:props) { CollageFactory.send(:build_props, arguments) }
    let(:montage_props) { CollageFactory.send(:build_montage_props, props) }

    # Expected attributes
    let(:padding_x) { props[:width]  * 0.01 }
    let(:padding_y) { props[:height] * 0.01 }
    let(:image_dim_width)  { (props[:width]  - 6 * padding_x) / props[:tile_h] }
    let(:image_dim_height) { (props[:height] - 6 * padding_y) / props[:tile_v] }

    it 'should have correct attributes' do
      expect(montage_props[:font]).to eq('DejaVu-Sans')
      expect(montage_props[:tile]).to eq("#{props[:tile_h]}x#{props[:tile_v]}")
      expect(montage_props[:background_color]).to eq('#ffffff')
      expect(montage_props[:geometry]).to eq("#{image_dim_width}x#{image_dim_height}+#{padding_x}+#{padding_y}")
      expect(montage_props[:shadow]).to be true
    end
  end
end
