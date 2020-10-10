# frozen_string_literal: true

require 'yaml'

require 'xssh/version'
require 'xssh/factory'
require 'xssh/template'

module Xssh
  class Error < StandardError; end
  class << self
    def get(name, **opts, &block)
      opts     = factory.inventory[name].merge(opts)
      type     = opts[:type]
      template = factory.templates[type]
      session  = template.build(name, **opts)

      return session unless block

      yield  session
      begin
        session.close
      rescue StandardError
        nil
      end
    rescue StandardError => e
      raise Error, e
    end

    def list(**query)
      factory.query(query)
    end

    def find(**query)
      list(**query).first
    end

    def configure(&block)
      instance_eval(&block)
    end

    def source(*args)
      args.flatten.each do |src|
        case src
        when /\.y(a)?ml$/
          factory.yaml(src)
        when String
          if File.exist?(src)
            factory.dsl(IO.read(src))
          else
            factory.dsl(src)
          end
        when Hash
          name = src.delete(:name)
          factory.set_source(name, **src)
        when Array
          src.each do |s|
            name = s.delete(:name)
            factory.set_source(name, **s)
          end
        end
      end
    end

    def template(*templates, **opts, &block)
      name = opts[:type]

      if block
        template = factory.templates[name] || Template.new(name)
        template.instance_eval(&block)
        factory.templates[name] = template
        return
      end

      templates = templates.map { |path| Dir.exist?(path) ? Dir.glob(File.join(path, '*.rb')) : path }.flatten
      templates.each do |path|
        name     ||= File.basename(path, '.rb').scan(/\w+/).join('_').to_sym
        text       = IO.read(path)
        template   = factory.templates[name] || Template.new(name)
        template.instance_eval(text)

        factory.templates[name] = template
      end
    end

    private

    def factory
      @factory ||= Factory.instance
    end
  end
end
