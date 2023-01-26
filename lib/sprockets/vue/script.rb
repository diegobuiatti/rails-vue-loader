require 'tilt'

module Sprockets
  module Vue
    # Compile Vue assets to javascript
    class Script < Tilt::Template
      STYLE_REGEX = Utils.node_regex('style')
      SCRIPT_REGEX = Utils.node_regex('script')
      TEMPLATE_REGEX = Utils.node_regex('template')

      SCRIPT_COMPILES = {
        'coffee' => ->(content) { CoffeeScript.compile(content, no_wrap: true) },
        nil => ->(content) { content }
      }.freeze

      TEMPLATE_COMPILES = {
        'slim' => ->(content) { Slim::Template.new { content }.render },
        'slm' => ->(content) { Slim::Template.new { content }.render },
        nil => ->(content) { content }
      }.freeze

      def initialize(filename, &block)
        @filename = filename
        super
      end

      self.default_mime_type = 'application/javascript'

      def prepare; end

      def evaluate(_scope, _locals, &_block)
        return data if style?

        script = SCRIPT_REGEX.match(data)
        template = TEMPLATE_REGEX.match(data)
        output = []

        output << mount_script(script) if script
        output << mount_template(template) if template

        wrap(output.join)
      end

      private

      def style?
        @filename.match(/\.style\.vue/) != nil
      end

      def name
        output = @filename.split('.').first
        output.gsub!('/index', '') if output.ends_with? '/index'

        output = output.split('/').last
        output.gsub('-', '_').camelize
      end

      def mount_script(opts)
        result = SCRIPT_COMPILES[opts[:lang]].call(opts[:content])
        output = "'object' != typeof VComponents && (this.VComponents = {});var module = { exports: null };"
        output + "#{result};VComponents['#{name}'] = module.exports;"
      end

      def mount_template(opts)
        result = TEMPLATE_COMPILES[opts[:lang]].call(opts[:content])
        "VComponents['#{name.sub(/\.tpl$/, '')}'].template = '#{Utils.escape_javascript(result)}';"
      end

      def wrap(content)
        "(function(){#{content}}).call(this);"
      end
    end
  end
end
