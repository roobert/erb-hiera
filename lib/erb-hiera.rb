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
      input           = mapping["dir"]["input"]
      output          = mapping["dir"]["output"]

      [:input, :output].each do |location|
        raise StandardError, "error: undefined #{dir.to_s.split('_')[0]}put" unless binding.local_variable_get(location)
      end

      # if input is a file then out_file is a file too
      if input =~ /.erb$/
        generate(output, input)
        next
      end

      # otherwise the input/output are directories and all files should be processed..
      manifests(input).each do |manifest|
        out_file = File.join(output, manifest.gsub(input, ""))
        generate(out_file, manifest)
      end
    end
  rescue => error
    handle_error(error)
    exit 1
  end

  private

  def self.generate(out_file, manifest)
    Manifest.info(manifest, out_file) if options[:verbose]

    erb = ERB.new(File.read(manifest), nil, "-").result(Hiera.get_binding)

    puts erb if options[:verbose]

    unless options[:dry_run]
      FileUtils.mkdir_p File.dirname(out_file) unless Dir.exists?(File.dirname(out_file))
      File.write(out_file, erb)
    end
  end

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
