require 'rubygems'
require 'bundler/setup'

require 'file_convert' # and any other gems you need

#"#{RSpec.configure do |config|
  # some (optional) config here
#end

def load_config
  config_values ||= YAML.load_file('./config/config.yml')

  @configuration = {
    drive_key_path: config_values['DRIVE_KEY_PATH'],
    drive_service_account: config_values['DRIVE_SERVICE_ACCOUNT'],
    s3_key: config_values['S3_KEY'],
    s3_secret: config_values['S3_SECRET'],
    s3_bucket_name: config_values['S3_BUCKET'],
    system_folder: config_values['TMP_FOLDER']
  }
end

def set_fixture_file_names
  @doc = 'james.doc'
  @docx = 'justin.docx'
  @pdf = 'jane.pdf'
  @doc_path = "./spec/fixtures/#{@doc}"
  @docx_path = "./spec/fixtures/#{@docx}"
  @pdf_path = "./spec/fixtures/#{@pdf}"
end


def upload_fixtures_to_s3
  load_config
  set_fixture_file_names
  FileConvert::Bucket.new(@configuration[:s3_key], @configuration[:s3_secret], @configuration[:s3_bucket_name], @configuration[:system_folder])
  AWS::S3::S3Object.store(@doc, open(@doc_path), @configuration[:s3_bucket_name])
  AWS::S3::S3Object.store(@docx, open(@docx_path), @configuration[:s3_bucket_name])
  AWS::S3::S3Object.store(@pdf, open(@pdf_path), @configuration[:s3_bucket_name])
end

def remove_fixtures_from_s3
  AWS::S3::S3Object.delete(@doc, @configuration[:s3_bucket_name])
  AWS::S3::S3Object.delete(@docx, @configuration[:s3_bucket_name])
  AWS::S3::S3Object.delete(@pdf, @configuration[:s3_bucket_name])
end
