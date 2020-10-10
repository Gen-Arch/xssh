# frozen_string_literal: true

require 'xssh/connection'

module Xssh
  class Template
    DEFAULT_TIMEOUT  = 10
    DEFAULT_PROMPT   = /[$%#>] ?\z/n.freeze

    attr_reader :methods
    attr_reader :prompts
    attr_reader :timeout

    def initialize(name)
      @name    = name
      @prompts = []
      @timeout = DEFAULT_TIMEOUT
      @methods = {}
    end

    def prompt(expect = nil, &block)
      return [[DEFAULT_PROMPT, nil]] if expect.nil? && @prompts.empty?

      @prompts << [Regexp.new(expect.to_s), block] if expect
      @prompts
    end

    def prompt_patten
      Regexp.union(prompt.map(&:first))
    end

    def bind(name, &block)
      @methods[name] = block
    end

    def build(name, **opts)
      klass = Class.new(Xssh.const_get('Connection'))
      klass.class_exec(self) do |template|
        template.methods.each { |name, block| define_method(name, &block) }
      end
      klass.new(self, name, **opts)
    end
  end
end
