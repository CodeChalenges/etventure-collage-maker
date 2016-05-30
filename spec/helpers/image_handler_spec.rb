require "spec_helper"
require 'securerandom'
require "helpers/image_handler"

RSpec.describe ImageHandler do
  let(:image_url) { "http://www.etventure.com/wp-content/themes/etvenrure.com/_/img/logo.png" }
  let!(:tmp_file) { ImageHandler.download(image_url) }

  # Cleanup trash generated during tests
  after { File.delete(tmp_file) if File.exist?(tmp_file) }

  describe "download" do
    it "should store file in /tmp dir" do
      expect(tmp_file).to_not be_nil
      expect(File.exist?(tmp_file)).to be true
    end
  end

  describe "clean" do
    context 'image exists' do
      before { ImageHandler.clean(tmp_file) }

      it "should remove temporary file" do
        expect(File.exist?(tmp_file)).to be false
      end
    end

    context 'image doesn\'t exists' do
      subject { ImageHandler.clean("#{SecureRandom.hex}.jpg") }
      it { is_expected.to be false }
    end
  end
end
