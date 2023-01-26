require 'sprockets'
require 'sprockets/vue/version'
require 'sprockets/vue/utils'
require 'sprockets/vue/script'
require 'sprockets/vue/style'

module Sprockets
  if respond_to?(:register_engine)
    register_engine '.vue', Vue::Script
    register_engine '.style', Vue::Style
  end
end
