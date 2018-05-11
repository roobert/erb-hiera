require "hiera"

module ErbHiera
  module Hiera
    def self.erb_hiera
      @hiera ||= begin
        hiera = ::Hiera.new(:config => ErbHiera.options[:hiera_config])
        hiera.config[:backends].insert(0, "hash") unless hiera.config[:backends][0] == "hash"
        ::Hiera.logger = logger_type

        if ErbHiera.options[:debug_given]
          puts "# hiera config"
          puts hiera.config.to_yaml
        end

        hiera
      end
    end

    def self.dump_config
    end

    def self.hiera(key)
      value = erb_hiera.lookup(key, nil, ErbHiera.scope, nil, :priority)

      unless value
        puts "\nerror: cannot find value for key: #{key}"
        exit 1
      end

      puts "# #{key}: #{value}" if ErbHiera.options[:verbose]
      value
    end

    def self.hiera_array(key)
      value = erb_hiera.lookup(key, nil, ErbHiera.scope, nil, :array)

      unless value
        puts "\nerror: cannot find value for key: #{key}"
        exit 1
      end

      puts "# #{key}: #{value}" if ErbHiera.options[:verbose]
      value
    end

    def self.hiera_hash(key)
      value = erb_hiera.lookup(key, nil, ErbHiera.scope, nil, :hash)

      unless value
        puts "\nerror: cannot find value for key: #{key}"
        exit 1
      end

      puts "# #{key}: #{value}" if ErbHiera.options[:verbose]
      value
    end

    private

    def self.logger_type
      return "console" if ErbHiera.options[:debug_given]
      "noop"
    end

    # bind calls from template to context of this module
    def self.get_binding
      binding
    end
  end
end
