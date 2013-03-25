require 'rubygems'
require_relative 'drive'
require_relative 'docs'

config = YAML.load_file('../config/config.yml')

drive = Drive.new config
docs = Docs.new config

txt_url1 = drive.txt_url '/Users/sina/Downloads/Resume_Jane.pdf'
txt_url2 = drive.txt_url '/Users/sina/Downloads/My Resume.docx'
puts txt_url1
puts txt_url2

puts docs.get(txt_url1, '/tmp/docs')
puts docs.get(txt_url2, '/tmp/docs')
