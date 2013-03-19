require 'rubygems'
require_relative 'drive'


drive = Drive.new
txt_url = drive.txt_url '/Users/sina/Downloads/Resume_Jane.pdf'
puts txt_url