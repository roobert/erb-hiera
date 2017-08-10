module ErbHiera
  module Manifest
    def self.info(manifest, out_file)
      puts heading(out_file)
      puts "#"
      puts "# scope:"
      puts "#{ErbHiera.scope.to_yaml.to_s.gsub(/^/, '# ')}"
      puts "#"
      puts "# in:  #{manifest}"
      puts "# out: #{out_file}"
      puts "#"
    end

    def self.heading(out_file)
      "\n# #{out_file.gsub(/.*\/conf\//, '').split("/").join(" / ")}"
    end
  end
end
