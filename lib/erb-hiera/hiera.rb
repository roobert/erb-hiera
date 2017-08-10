require "hiera"

module ErbHiera
  module Hiera
    def self.hiera(key)
      config = File.join(Directory.root, "hiera.yaml")

      hiera = ::Hiera.new(:config => config)
      ::Hiera.logger = "noop"
      value = hiera.lookup(key, nil, ErbHiera.scope, nil, :priority)

      unless value
        puts "\nerror: cannot find value for key: #{key}"
        exit 1
      end

      puts "# #{key}: #{value}" if ErbHiera.options[:verbose]
      value
    end

    def self.get_binding
      binding
    end
  end
end
