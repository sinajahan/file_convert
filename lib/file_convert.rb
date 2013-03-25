require 'rubygems'
require 'tempfile'

class FileConvert
  def self.configure(&block)
    yield(configuration)
    configuration
  end

  def self.configuration
    @config ||= FileConvert::Configuration.new
  end


  def initialize
    @drive = Drive.new FileConvert.configuration
    @docs = Docs.new FileConvert.configuration
    @bucket = Bucket.new FileConvert.configuration
  end

  def to_txt_from_s3(s3_file_key)
    s3_file = @bucket.download s3_file_key
    convert_txt_url = @drive.get_convert_txt_url s3_file.path
    @docs.download_and_read(convert_txt_url)
  end

  def self.get_a_temp_file(key = '')
    Tempfile.new(['file_convert', key], configuration.tmp_folder)
  end
end

require 'file_convert/drive'
require 'file_convert/docs'
require 'file_convert/bucket'
require 'file_convert/configuration'



