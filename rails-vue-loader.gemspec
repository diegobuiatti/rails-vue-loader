$:.unshift File.expand_path("../lib", __FILE__)
require 'sprockets/vue/version'

Gem::Specification.new do |s|
  s.name    = 'rails-vue-loader'
  s.version = Sprockets::Vue::VERSION

  s.homepage    = "https://github.com/kikyous/rails-vue-loader"
  s.summary     = "Sprockets Vue transformer"
  s.description = <<-EOS
                A Sprockets transformer that converts .vue file into js object.
  EOS
  s.license = "MIT"

  s.files = Dir["README.md", "MIT-LICENSE", "lib/**/*.rb"]

  s.add_dependency 'sprockets', '~> 2.2.3'
  s.add_dependency 'tilt', "~> 1.4.1"
  s.add_dependency 'css_parser', '~> 1.3.6'
  s.add_development_dependency 'concurrent-ruby', '1.0.0'
  s.add_development_dependency 'public_suffix', '~> 1.5.3'
  s.add_development_dependency 'rb-inotify', '~> 0.9.6'
  s.add_development_dependency 'ffi', '~> 1.9.10'
  s.add_development_dependency 'rake', '~> 10.5.0'
  s.add_development_dependency 'minitest', '~> 5.8.2'
  s.add_development_dependency 'execjs'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'sass'
  s.add_development_dependency 'coffee-script'

  s.authors = ['kikyous']
  s.email   = 'kikyous@163.com'
end
