require 'rubygems'
require_relative 'drive'
require_relative 'docs'
require_relative 'bucket'
require 'tempfile'

class FileConvert

  def self.get_a_temp_file(key = '')
    config = YAML.load_file('../config/config.yml')
    Tempfile.new(['file_convert', key], config['TMP_FOLDER'])
  end
end

config = YAML.load_file('../config/config.yml')


drive = Drive.new config
docs = Docs.new config
bucket = Bucket.new config


s3_file = bucket.download 'L5sjwgzRomh85km8J7S7_My Resume (1).docx'
txt_url1 = drive.get_convert_txt_url s3_file
puts txt_url1

puts docs.download(txt_url1)

