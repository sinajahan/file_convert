require 'aws/s3'

class FileConvert::Bucket
  def initialize(config)
    AWS::S3::Base.establish_connection!(
      access_key_id: config.s3_key,
      secret_access_key: config.s3_secret
    )

    @bucket = AWS::S3::Bucket.find('clearfit-thumbnails-development')
  end

  def download(key)
    temp_file = FileConvert.get_a_temp_file key
    file_with_key = @bucket[key]
    raise "There is no file with the key [#{key}]" if file_with_key.nil?
    File.open(temp_file, 'w') { |file| file.write(file_with_key.value) }
    temp_file
  end
end