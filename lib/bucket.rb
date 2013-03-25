require 'aws/s3'


class Bucket
  def initialize(config)
    AWS::S3::Base.establish_connection!(
      access_key_id: config['S3_KEY'],
      secret_access_key: config['S3_SECRET']
    )
    @bucket = AWS::S3::Bucket.find('clearfit-thumbnails-development')
  end

  def download(key)
    temp_file = FileConvert.get_a_temp_file key
    File.open(temp_file, 'w') { |file| file.write(@bucket[key].value) }
    temp_file.path
  end
end