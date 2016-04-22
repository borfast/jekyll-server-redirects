require File.expand_path('../lib/jekyll-server-redirects/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'jekyll-server-redirects'
  s.version = Jekyll::ServerRedirects::VERSION
  s.date = '2016-04-22'
  s.summary = 'Server redirects for Jekyll'
  s.description = 'Generate server redirects for Jekyll.'
  s.authors = ['Raúl Santos']
  s.email = 'borfast@gmail.com'
  s.files = Dir["lib/**/*"]
  s.homepage = 'https://github.com/borfast/jekyll-server-redirects'
  s.license = 'MIT'
  s.add_development_dependency 'jekyll', '~> 3.0'
end
