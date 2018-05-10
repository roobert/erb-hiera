#!/usr/bin/env ruby

require "erb"
require "yaml"
require "json"
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
      ErbHiera.scope  = scope_from_cli   || mapping["scope"]
      input           = options[:input]  || mapping["dir"]["input"]
      output          = options[:output] || mapping["dir"]["output"]

      [:input, :output].each do |location|
        unless binding.local_variable_get(location)
          raise StandardError, "error: undefined #{dir.to_s.split('_')[0]}put"
        end
      end

      output = STDOUT if output == "-"

      # if input is a file/stdin then out_file should be a file/stdout
      if input =~ /.erb$/ || input == STDIN
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
  end

  private

  def self.scope_from_cli
    JSON.load(options[:scope]) if options[:scope]
  end

  def self.generate(out_file, manifest)
    Manifest.info(manifest, out_file) if options[:verbose]
    erb = ERB.new(File.read(manifest), nil, "-").result(Hiera.get_binding)

    puts erb if options[:verbose]

    return if options[:dry_run]

    if out_file == STDOUT
      puts erb
      return
    end

    FileUtils.mkdir_p File.dirname(out_file) unless Dir.exists?(File.dirname(out_file))
    File.write(out_file, erb)
  end

  def self.handle_error(error)
    if options[:debug]
      puts
      puts error.backtrace
    end

    puts
    puts error
    exit 1
  end

  def self.mappings
    YAML.load_file(ErbHiera.options[:mapping_config])
  end

  def self.manifests(dir)
    Dir.glob(File.join(dir, "**", "*")).reject { |file| File.directory? file }
  end
end
