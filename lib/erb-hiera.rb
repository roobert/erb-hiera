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

    mappings.each do |mapping|
      ErbHiera.scope  = mapping["scope"]
      in_dir          = mapping["dir"]["input"]
      out_dir         = mapping["dir"]["output"]

      [:in_dir, :out_dir].each do |dir|
        raise StandardError, "error: undefined #{dir.to_s.split('_')[0]}put directory" unless binding.local_variable_get(dir)
      end

      manifests(in_dir).each do |manifest|
        out_file = File.join(out_dir, manifest.gsub(in_dir, ""))

        Manifest.info(manifest, out_file) if options[:verbose]

        erb = ERB.new(File.read(manifest), nil, "-").result(Hiera.get_binding)

        puts erb if options[:verbose]

        unless options[:dry_run]
          FileUtils.mkdir_p File.dirname(out_file) unless Dir.exists?(File.dirname(out_file))
          File.write(out_file, erb)
        end
      end
    end
  rescue => error
    handle_error(error)
    exit 1
  end

  private

  def self.handle_error(error)
    if options[:debug]
      puts
      puts error.backtrace
    end

    puts
    puts error
  end

  def self.mappings
    YAML.load_file(options[:config])
  end

  def self.manifests(dir)
    Dir.glob(File.join(dir, "**", "*")).reject { |file| File.directory? file }
  end
end
