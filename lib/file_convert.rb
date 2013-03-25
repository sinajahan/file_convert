require 'rubygems'
require_relative 'drive'
require_relative 'docs'
require_relative 'bucket'
require 'tempfile'

class FileConvert
  def initialize
    @config ||= YAML.load_file('../config/config.yml')
    @drive = Drive.new @config
    @docs = Docs.new @config
    @bucket = Bucket.new @config
  end

  def convert(s3_file_key)
    s3_file = @bucket.download s3_file_key
    convert_txt_url = @drive.get_convert_txt_url s3_file
    @docs.download_and_read(convert_txt_url)
  end

  def self.get_a_temp_file(key = '')
    @config ||= YAML.load_file('../config/config.yml')
    Tempfile.new(['file_convert', key], @config['TMP_FOLDER'])
  end
end

converter = FileConvert.new
puts converter.convert 'L5sjwgzRomh85km8J7S7_My Resume (1).docx'





