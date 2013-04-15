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
      file_with_key = @bucket.objects[key]
      raise UserError, "There is no file with the key [#{key}]" if file_with_key.nil?
      File.open(temp_file, 'w') do |file|
        file_with_key.read do |chunk|
          file.write(chunk.force_encoding('UTF-8'))
        end
      end
      temp_file
    end

    private

    def create_bucket
      s3 = AWS::S3.new(
        :access_key_id => @key,
        :secret_access_key => @secret)
      @bucket = s3.buckets[@bucket_name]
    end

    def get_a_temp_file(key = '')
      Tempfile.new(['file_convert', key], @system_folder)
    end
  end
end