require "spec_helper"
require 'uri'
require "services/flickr_service"

RSpec.describe FlickrService do
  let(:flickr_service) { FlickrService.instance }

  context 'common keyword' do
    let(:keyword) { 'Berlin' }
    let(:img_url) { flickr_service.get_photo_by_keyword(keyword) }

    it 'should get a valid URL' do
      expect(img_url).to_not be_nil
      expect(img_url =~ URI::regexp).to eq(0)
    end
  end

  context 'unexistent keyword' do
    # What a bad luck if the keyword below in fact exists :P
    let(:keyword) { 'icnzidzidvozdbvpzidvpzdnvzndvzndvkzmdvzdnvzdi' }
    let(:img_url) { flickr_service.get_photo_by_keyword(keyword)    }

    it { expect(img_url).to be_nil }
  end

  context 'empty keyword' do
    let(:img_url) { flickr_service.get_photo_by_keyword('') }

    it { expect(img_url).to be_nil }
  end

  context 'nil keyword' do
    let(:img_url) { flickr_service.get_photo_by_keyword(nil) }

    it { expect(img_url).to be_nil }
  end
end
