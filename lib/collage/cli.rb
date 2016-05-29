require 'thor'
require 'logging'
require 'etventure_collage_maker'

module EtventureCollageMaker
  class Cli < Thor
    desc "create", "build the collage"
    method_option :keywords, aliases: '-k', desc: "A list of keywords, separated by comma"
    method_option :width,    aliases: '-w', desc: "Collage width"
    method_option :height,   aliases: '-h', desc: "Collage height"
    method_option :output,   aliases: '-o', desc: "Collage output file"
    def create
      opts = build_opts(options)

      # Logging setup
      Logging.logger.root.level = :info
      Logging.logger.root.appenders = Logging.appenders.stdout

      EtventureCollageMaker.create(opts)
    end

    private
      def build_opts(cli_options)
        opts = {}

        opts[:keywords] = cli_options[:keywords].nil? ? [] : cli_options[:keywords].split(',')
        opts[:width]    = cli_options[:width] unless cli_options[:width].nil?
        opts[:height]   = cli_options[:height] unless cli_options[:height].nil?
        opts[:output]   = cli_options[:output] unless cli_options[:output].nil?

        return opts
      end
  end
end
