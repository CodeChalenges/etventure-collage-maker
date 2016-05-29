require 'spec_helper'
require 'collage'

describe Collage do
  let(:keywords) {[
    'Berlin', 'Germany', 'Europe', 'Computing', 'Ruby',
    'Software', 'Startup', 'Work', 'Job', 'Happiness'
  ]}
  let(:output_file) { 'output.jpg' }
  before { Collage.create(keywords) }
  after  { File.delete(output_file) if File.exist?(output_file) }

  it "should generate collage file" do
    expect(File.exist?(output_file)).to be true
  end
end
