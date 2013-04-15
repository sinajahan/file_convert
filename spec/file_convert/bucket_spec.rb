require_relative '../spec_helper'

describe FileConvert::Bucket do
  before do
    @aws_bucket = mock(AWS::S3::Bucket)
    AWS::S3::Base.should_receive(:establish_connection!)
    .with({:access_key_id=>:key, :secret_access_key=>:secret})
    .and_return
    @s3_file = mock(AWS::S3::S3Object)
    AWS::S3::Bucket.should_receive(:find).with(:bucket_name).and_return(@aws_bucket)
    AWS::S3::S3Object.should_receive(:find).with(:key, :bucket_name).and_return(@s3_file)
    @temp_file = mock(Tempfile)
    Tempfile.should_receive(:new).and_return(@temp_file)
    File.should_receive(:open).and_return
  end

  it 'should download a file with the given key' do
    bucket = FileConvert::Bucket.new :key, :secret, :bucket_name, :system_folder
    downloaded = bucket.download :key
    downloaded.should == @temp_file
  end
end