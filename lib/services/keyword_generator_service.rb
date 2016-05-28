require 'singleton'

class KeywordGeneratorService
  include Singleton

  attr_reader :keyword_buffer

  def initialize
    @keyword_buffer = Queue.new
    fill_buffer
  end

  def next_keyword
    if @keyword_buffer.empty?
      fill_buffer
    end

    @keyword_buffer.pop
  end

  private
    # Buffer is filled with 20 random words, to reduce the amount
    # of time spent doing IO related operations.
    #
    # When buffer is fully consumed, another 20 random words are
    # fetched.
    def fill_buffer
      lines = File.readlines('/usr/share/dict/words')

      20.times do
        @keyword_buffer.push(lines.sample)
      end
    end
end
