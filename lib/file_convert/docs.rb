require 'gdata/client'
require 'gdata/http'
require 'gdata/auth'

class FileConvert::Docs
  def initialize(config)
    @client = GData::Client::Spreadsheets.new
    @client.clientlogin(config.user_name, config.password)
  end

  def download_and_read(url)
    temp_file = FileConvert.get_a_temp_file
    content = @client.get(url)
    File.open(temp_file, 'w') { |file| file.write(content.body) }
    File.read(temp_file)
  end
end
