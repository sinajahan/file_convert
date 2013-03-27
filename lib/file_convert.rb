require 'rubygems'
require 'tempfile'

require 'file_convert/drive'
require 'file_convert/bucket'

module FileConvert
  class Converter
    def initialize(params)
      @drive = Drive.new(params[:drive_key_path], params[:drive_service_account])
      @bucket = Bucket.new(params[:s3_key], params[:s3_secret], params[:s3_bucket_name], params[:system_folder])
    end

    def to_txt_from_s3(s3_file_key)
      s3_file = @bucket.download s3_file_key
      @drive.get_txt s3_file.path
    end
  end
end


