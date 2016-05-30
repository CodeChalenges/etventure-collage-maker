require "spec_helper"
require "collage/cli"

RSpec.describe EtventureCollageMaker::Cli do
  describe "create" do
    let(:args) {
      %w[ create -k Berlin,Germany,Europe,Ruby,Software -w 2000 -h 1000 -o my_collage.jpg]
    }

    before { EtventureCollageMaker::Cli.start(args) }
    after  { File.delete('my_collage.jpg') if File.exist?('my_collage.jpg') }

    it { expect(File.exist?('my_collage.jpg')).to be true }
  end

  describe 'build_opts' do
    let(:cli) { EtventureCollageMaker::Cli.new }
    let(:input) {
      {
        keywords: 'A,B,C',
        width: 1000,
        height: 500,
        output: 'abc.jpg'
      }
    }
    let(:opts) { cli.send(:build_opts, input) }

    it 'should parse keywords' do
      expect(opts[:keywords]).to eq(input[:keywords].split(','))
    end

    it 'should parse width' do
      expect(opts[:width]).to eq(input[:width])
    end

    it 'should parse height' do
      expect(opts[:height]).to eq(input[:height])
    end

    it 'should parse output file' do
      expect(opts[:output]).to eq(input[:output])
    end
  end
end
