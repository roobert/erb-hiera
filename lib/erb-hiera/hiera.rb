require "hiera"

module ErbHiera
  module Hiera
    def self.erb_hiera
      @hiera ||= begin
        hiera = ::Hiera.new(:config => ErbHiera.options[:hiera_config])

        # injecting the Hash backend ensures that the --variables flag will always work as expected
        hiera.config[:backends].insert(0, "hash") unless hiera.config[:backends][0] == "hash"

        ::Hiera.logger = ErbHiera.options[:debug_given] ? "console" : "noop"

        if ErbHiera.options[:debug_given]
          puts "# hiera config"
          puts hiera.config.to_yaml
        end

        hiera
      end
    end

    def self.hiera(key, type: :priority)
      value = erb_hiera.lookup(key, nil, ErbHiera.scope, nil, type)

      unless value
        puts "\nerror: cannot find value for key: #{key}"
        exit 1
      end

      puts "# #{key}: #{value}" if ErbHiera.options[:verbose]
      value
    end

    def self.hiera_array(key)
      hiera(key, type: :array)
    end

    def self.hiera_hash(key)
      hiera(key, type: :hash)
    end

    private

    # bind calls from template to context of this module
    def self.get_binding
      binding
    end
  end
end
