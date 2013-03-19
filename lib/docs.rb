require 'gdata/client'
require 'gdata/http'
require 'gdata/auth'

class Docs
  def initialize(config)
    @client = GData::Client::Spreadsheets.new
    @client.clientlogin(config['USER_NAME'], config['PASSWORD'])
  end

  def get(url, tmp_folder)
    random = (0...8).map{(65+rand(26)).chr}.join
    temp_file = "#{tmp_folder}/#{random}"
    test = @client.get(url)
    file = File.new("#{tmp_folder}/#{random}", 'wb')
    file.write test.body
    file.close
    data = File.read(temp_file)
  end
end
