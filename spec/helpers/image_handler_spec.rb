require "spec_helper"
require "helpers/image_handler"

RSpec.describe ImageHandler do
  let(:image_url) { "http://www.etventure.com/wp-content/themes/etvenrure.com/_/img/logo.png" }
  let!(:tmp_file) { ImageHandler.download(image_url) }

  # Cleanup trash generated during tests
  after { File.delete(tmp_file) if File.exist?(tmp_file) }

  context "download" do
    it "should store file in /tmp dir" do
      expect(tmp_file).to_not be_nil
      expect(File.exist?(tmp_file)).to be true
    end
  end

  context "clean" do
    before { ImageHandler.clean(tmp_file) }

    it "should remote temporary file" do
      expect(File.exist?(tmp_file)).to be false
    end
  end
end
