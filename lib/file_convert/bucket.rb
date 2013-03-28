require 'aws/s3'

module FileConvert
  class Bucket

    def initialize(key, secret, bucket_name, system_folder)
      @key = key
      @secret = secret
      @bucket_name = bucket_name
      @system_folder = system_folder
      create_bucket
    end

    def download(key)
      temp_file = get_a_temp_file key
      file_with_key = @bucket[key]
      raise UserError, "There is no file with the key [#{key}]" if file_with_key.nil?
      File.open(temp_file, 'w') { |file| file.write(file_with_key.value) }
      temp_file
    end

    private

    def create_bucket
      AWS::S3::Base.establish_connection!(
        access_key_id: @key,
        secret_access_key: @secret
      )
      @bucket = AWS::S3::Bucket.find(@bucket_name)
    end

    def get_a_temp_file(key = '')
      Tempfile.new(['file_convert', key], @system_folder)
    end
  end
end