require "trollop"

module ErbHiera
  module CLI
    def self.parse
      option_parser = Trollop::Parser.new do
        opt :mapping_config, "specify mapping config file",       :type => :string, :short => :m
        opt :hiera_config,   "specify hiera config file\n ",      :type => :string, :short => :c

        opt :input,          "override input config options",     :type => :string, :short => :i
        opt :output,         "override output config options\n ", :type => :string, :short => :o

        opt :scope,          "override the lookup scope",         :type => :string, :short => :s
        opt :variables,      "override facts\n ",                 :type => :string, :short => :v

        opt :dry_run,        "don't write out files\n "

        opt :verbose,        "print compiled templates"
        opt :debug,          "enable hiera logging and print backtrace on error\n "
      end

      options = Trollop.with_standard_exception_handling(option_parser) do
        # show help if no cli args are provided
        raise Trollop::HelpNeeded if ARGV.empty?

        option_parser.parse ARGV
      end

      # validate cli args
      #if (options[:config] && options[:template]) || ( ! options[:config] && ! options[:template])
      #  raise ArgumentError, "either config or template must be defined but not both"
      #end

      if options[:config_given]
        raise ArgumentError, "config file not readable"  unless File.readable?(options[:config])
      end

      raise ArgumentError, "hiera config file not specified" unless options[:hiera_config_given]
      raise ArgumentError, "hiera config file not readable"  unless File.readable?(options[:hiera_config])

      options
    rescue => error
      puts error
      puts error.backtrace if options[:debug]
      exit 1
    end
  end
end
