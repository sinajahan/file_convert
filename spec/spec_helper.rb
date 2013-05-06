require 'rubygems'
require 'bundler/setup'
require 'pry'

require 'file_convert'

def load_config
  config_values ||= YAML.load_file('./config/config.yml')

  @configuration = {
    s3_key: config_values['S3_KEY'],
    s3_secret: config_values['S3_SECRET'],
    s3_bucket_name: config_values['S3_BUCKET'],
    system_folder: config_values['SYSTEM_FOLDER']
  }

  @doc = 'james.doc'
  @docx = 'justin.docx'
  @pdf = 'jane.pdf'
  @txt = 'jack.txt'
  @doc_path = "./spec/fixtures/#{@doc}"
  @docx_path = "./spec/fixtures/#{@docx}"
  @pdf_path = "./spec/fixtures/#{@pdf}"
  @txt_path = "./spec/fixtures/#{@txt}"

  s3 = AWS::S3.new(
    :access_key_id => @configuration[:s3_key],
    :secret_access_key => @configuration[:s3_secret])
  @bucket = s3.buckets[@configuration[:s3_bucket_name]]

  @configuration
end

def upload_fixtures_to_s3
  load_config
  obj = @bucket.objects[@doc]
  obj.write(Pathname.new(@doc_path))
  obj = @bucket.objects[@docx]
  obj.write(Pathname.new(@docx_path))
  obj = @bucket.objects[@pdf]
  obj.write(Pathname.new(@pdf_path))
  obj = @bucket.objects[@txt]
  obj.write(Pathname.new(@txt_path))
end

def remove_fixtures_from_s3
  obj = @bucket.objects[@doc]
  obj.delete
  obj = @bucket.objects[@docx]
  obj.delete
  obj = @bucket.objects[@pdf]
  obj.delete
  obj = @bucket.objects[@txt]
  obj.delete
end
