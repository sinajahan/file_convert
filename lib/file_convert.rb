require 'rubygems'
require_relative 'drive'


drive = Drive.new
txt_url1 = drive.txt_url '/Users/sina/Downloads/Resume_Jane.pdf'
txt_url2 = drive.txt_url '/Users/sina/Downloads/My Resume.docx'
puts txt_url1
puts txt_url2