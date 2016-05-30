require "spec_helper"
require "services/keyword_generator_service"

RSpec.describe KeywordGeneratorService do
  let(:keyword_generator_service) { KeywordGeneratorService.instance }
  let(:buffer) { keyword_generator_service.keyword_buffer }

  # Force buffer to be refilled before tests
  before { keyword_generator_service.send(:fill_buffer) }

  it 'should start with 20 keywords in buffer' do
    expect(buffer.size).to eq(20)
  end

  it 'should return a valid keyword in 20 calls' do
    20.times do
      keyword = keyword_generator_service.next_keyword
      expect(keyword).to_not be_nil
      expect(keyword).to_not be_empty
    end
  end

  context 'refill buffer' do
    before {
      20.times { keyword_generator_service.next_keyword }
    }

    it 'buffer should be empty' do
      expect(buffer.empty?).to be true
    end

    it 'should refill buffer' do
      # Should refill the buffer with 20 elements and return a keyword,
      # remaining 19 keyword in buffer
      keyword_generator_service.next_keyword
      expect(buffer.size).to eq(19)
    end
  end
end
