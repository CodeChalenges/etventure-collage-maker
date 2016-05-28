require 'rmagick'
require "spec_helper"
require "helpers/collage"

RSpec.describe Collage do
  let(:images) {
    [
      "spec/fixtures/images/dog1.jpg",
      "spec/fixtures/images/dog2.jpg",
      "spec/fixtures/images/dog3.jpg",
      "spec/fixtures/images/dog4.jpg",
      "spec/fixtures/images/dog5.jpg",
      "spec/fixtures/images/dog6.jpg",
      "spec/fixtures/images/dog7.jpg",
      "spec/fixtures/images/dog8.jpg",
      "spec/fixtures/images/dog9.jpg",
      "spec/fixtures/images/dog10.jpg"
    ]
  }
  let(:arguments) {
    {
      width: 1024,
      height: 768,
      output: "output.jpg",
      images: images
    }
  }

  # Collage cleanup
  after { File.delete(arguments[:output]) if File.exist?(arguments[:output]) }

  context 'build collage' do
    before { Collage.build(arguments) }
    let(:output_image)   { Magick::Image.read(arguments[:output]).first }
    let(:expected_image) { Magick::Image.read('spec/fixtures/images/expected_output.jpg').first }
    let(:difference)     { output_image.difference(expected_image) }

    # Errors
    let(:mean_error_per_pixel)     { difference[0] }
    let(:normalized_mean_error)    { difference[1] }
    let(:normalized_maximum_error) { difference[2] }

    it 'should generate the expected collage' do
      expect(mean_error_per_pixel).to     be_zero
      expect(normalized_mean_error).to    be_zero
      expect(normalized_maximum_error).to be_zero
    end
  end

  context "empty image list" do
    before { arguments[:images] = [] }
    it { expect{Collage.build(arguments)}.to raise_error(ArgumentError) }
  end

  context "nil image list" do
    before { arguments[:images] = nil }
    it { expect{Collage.build(arguments)}.to raise_error(ArgumentError) }
  end
end
