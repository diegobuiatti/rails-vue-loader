require 'css_parser'
require 'tilt'

module Sprockets
  module Vue
    # Compile Vue assets to stylesheet
    class Style < Tilt::Template
      self.default_mime_type = 'text/css'

      STYLE_REGEX = Utils.node_regex('style')

      STYLE_COMPILES = {
        'scss' => ->(x) { Sprockets::ScssProcessor.call(x)[:data] },
        'sass' => ->(x) { Sprockets::SassProcessor.call(x)[:data] },
        nil => ->(i) { i[:data] }
      }.freeze

      def initialize(filename, &block)
        @filename = filename
        super
      end

      def prepare; end

      def evaluate(_scope, _locals, &_block)
        style = STYLE_REGEX.match(data)
        if style
          STYLE_COMPILES[style[:lang]].call({ data: style[:content] })
        else
          ''
        end
      end
    end
  end
end
