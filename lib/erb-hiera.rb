#!/usr/bin/env ruby

require "erb"
require "yaml"
require "fileutils"

require "erb-hiera/version"
require "erb-hiera/cli"
require "erb-hiera/directory"
require "erb-hiera/hiera"
require "erb-hiera/manifest"

module ErbHiera
  class << self
    attr_accessor :options, :scope
  end

  def self.run
    @options = CLI.parse

    mappings.each do |config|
      ErbHiera.scope = config["scope"]
      in_dir          = config["in_dir"]
      out_dir         = config["out_dir"]

      manifests(in_dir).each do |manifest|
        out_file = File.join(out_dir ,manifest.gsub(in_dir, ""))

        Manifest.info(manifest, out_file) if options[:verbose]

        erb = ERB.new(File.read(manifest), nil, "-").result(Hiera.get_binding)

        puts erb if options[:verbose]

        unless options[:dry_run]
          FileUtils.mkdir_p File.dirname(out_file) unless Dir.exists?(File.dirname(out_file))
          File.write(out_file, erb)
        end
      end
    end
  end

  private

  def self.mappings
    YAML.load_file(File.join(Directory.root, "map.yaml"))
  end

  def self.manifests(dir)
    Dir.glob(File.join(dir, "**", "*.yaml"))
  end
end
