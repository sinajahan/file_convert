require 'rubygems'
require 'tempfile'

require 'file_convert/drive'
require 'file_convert/docs'
require 'file_convert/bucket'
require 'file_convert/configuration'

module FileConvert
  class Converter
    def self.configure(&block)
      yield(configuration)
      configuration
    end

    def self.configuration
      @config ||= Configuration.new
    end


    def initialize
      @drive = Drive.new Converter.configuration
      @docs = Docs.new Converter.configuration
      @bucket = Bucket.new Converter.configuration
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
end


