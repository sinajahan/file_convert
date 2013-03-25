Gem::Specification.new do |s|
  s.name        = 'file_convert'
  s.version     = '0.0.0'
  s.date        = '2013-03-18'
  s.summary     = 'convert files to different formats'
  s.description     = 'wrapper around google drive to convert files to different formats'
  s.authors     = ['Sina Jahan']
  s.email       = 'info@sinajahan.com'
  s.files       = %w(lib/file_convert.rb)
  s.homepage    =
    'http://rubygems.org/gems/file_convert'
  s.add_dependency('google-api-client', '~> 0.6.2')
  s.add_dependency('mime-types', '~> 1.21')
  s.add_dependency('gdata', '~> 1.1.2')
  s.add_dependency('aws-s3', '~> 0.6.3')
  s.add_development_dependency('rspec')
end