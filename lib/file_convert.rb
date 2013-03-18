require 'rubygems'
require 'google/api_client'
require 'launchy'
require 'yaml'

class FileConvert

  def self.read_config
    config = YAML.load_file('config/config.yml')
    @client_id = config['CLIENT_ID']
    @client_secret = config['CLIENT_SECRET']
    @oauth_scope = config['OAUTH_SCOPE']
    @redirect_uri = config['REDIRECT_URI']
  end

  def self.to_txt
    read_config

# Create a new API client & load the Google Drive API
    client = Google::APIClient.new
    drive = client.discovered_api('drive', 'v2')

# Request authorization
    client.authorization.client_id = @client_id
    client.authorization.client_secret = @client_secret
    client.authorization.scope = @oauth_scope
    client.authorization.redirect_uri = @redirect_uri

    uri = client.authorization.authorization_uri
    Launchy.open(uri)

# Exchange authorization code for access token
    $stdout.write "Enter authorization code: "
    client.authorization.code = gets.chomp
    client.authorization.fetch_access_token!

# Insert a file
    file = drive.files.insert.request_schema.new({
                                                   'title' => 'My document',
                                                   'description' => 'A test document',
                                                   'mimeType' => 'text/plain'
                                                 })

    media = Google::APIClient::UploadIO.new('document.txt', 'text/plain')
    result = client.execute(
      :api_method => drive.files.insert,
      :body_object => file,
      :media => media,
      :parameters => {
        'uploadType' => 'multipart',
        'alt' => 'json'})

# Pretty print the API result
    jj result.data.to_hash

  end
end