require 'active_support/concern'
require 'tilt'

module Sprockets::Vue
  class Script < Tilt::Template

    SCRIPT_REGEX = Utils.node_regex('script')
    TEMPLATE_REGEX = Utils.node_regex('template')

    SCRIPT_COMPILES = {
      'coffee' => ->(s, input){
        CoffeeScript.compile(s, sourceMap: false, sourceFiles: [input[:source_path]], no_wrap: true)
      },
      nil => ->(s, input){ { 'js' => s } }
    }

    TEMPLATE_COMPILES = {
      'slim' => ->(s) { Slim::Template.new { s }.render },
      'slm' => ->(s) { Slim::Template.new { s }.render },
      nil => ->(s) { s }
    }

    def initialize(filename, &block)
      @filename = filename
      @source   = block.call
      super
    end

    self.default_mime_type = 'application/javascript'

    def prepare; end

    def evaluate(scope, locals, &block)
      script = SCRIPT_REGEX.match(data)
      template = TEMPLATE_REGEX.match(data)
      output = []

      if script
        result = SCRIPT_COMPILES[script[:lang]].call(script[:content], @filename)
        output << "'object' != typeof VComponents && (this.VComponents = {});
          var module = { exports: null };
          #{result['js']}; VComponents['#{name}'] = module.exports;"
      end

      if template
        built_template = TEMPLATE_COMPILES[template[:lang]].call(template[:content])
        uniq_selector = Utils.scope_key(eval_file)
        built_template.sub!(/\>/, " data-#{uniq_selector}>")

        output << "VComponents['#{name.sub(/\.tpl$/, '')}'].template = '#{Utils.escape_javascript built_template}';"
      end

      "#{wrap(output.join)}"
    end

    private

    def name
      output = @filename.split('.').first
      output.gsub!('/index', '') if output.ends_with? '/index'

      output = output.split('/').last
      output.gsub('-', '_').camelize
    end

    def wrap(s)
      "(function(){#{s}}).call(this);"
    end
  end
end
