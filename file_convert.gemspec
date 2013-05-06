# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |s|
  s.name        = 'file_convert'
  s.version     = '0.0.15'
  s.executables << 'file_convert'
  s.date        = '2013-05-05'
  s.summary     = 'convert files to different formats'
  s.description     = 'wrapper around google drive to convert files to different formats'
  s.authors     = ['Sina Jahan']
  s.email       = 'info@sinajahan.com'

  s.files         = `git ls-files`.split($/)
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib', 'config']

  s.homepage    = 'http://rubygems.org/gems/file_convert'

  s.add_dependency('google-api-client', '~> 0.6.2')
  s.add_dependency('mime-types', '~> 1.21')
  s.add_dependency('aws-sdk', '~> 1.8.5')

  s.add_development_dependency('rspec')
end
