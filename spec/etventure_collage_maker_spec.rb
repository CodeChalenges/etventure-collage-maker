require 'spec_helper'
require 'etventure_collage_maker'

describe EtventureCollageMaker do
  # Should fetch 5 photos related to the keywords below and another 5 images
  # using random keywords
  let(:keywords) { ['Berlin', 'Germany', 'Europe', 'Computing', 'Ruby'] }
  let(:output_file) { 'output.jpg' }
  before { EtventureCollageMaker.create({keywords: keywords}) }
  after  { File.delete(output_file) if File.exist?(output_file) }

  it "should generate collage file" do
    expect(File.exist?(output_file)).to be true
  end
end
