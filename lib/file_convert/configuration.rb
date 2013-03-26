module FileConvert
  class Configuration
    attr_accessor :drive_key_path
    attr_accessor :drive_service_account

    attr_accessor :s3_key
    attr_accessor :s3_secret
    attr_accessor :s3_bucket

    attr_accessor :tmp_folder
  end
end