module ErbHiera
  module Directory
    def self.bin
      File.dirname(__FILE__)
    end

    def self.root
      File.join(bin, "..")
    end

    def self.output(manifest)
      Match.path(manifest, /manifest\/(.*)/)
    end

    module Match
      def self.path(path, regexp)
        result = path.match(regexp)

        if result.length != 2
          raise StandardError, "failed to match regexp for path: #{regexp}/#{path}"
        end

        result[1]
      end
    end
  end
end
