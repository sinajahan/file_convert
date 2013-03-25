require 'google/api_client'
require 'launchy'
require 'yaml'
require 'mime/types'

class Drive
  def initialize(config)
    # Get your credentials from the APIs Console
    client_id = config['CLIENT_ID']
    client_secret = config['CLIENT_SECRET']
    oauth_scope = 'https://www.googleapis.com/auth/drive'
    redirect_uri = 'urn:ietf:wg:oauth:2.0:oob'

    # Create a new API @client & load the Google Drive API
    @client = Google::APIClient.new
    @drive = @client.discovered_api('drive', 'v2')

    # Request authorization
    @client.authorization.client_id = client_id
    @client.authorization.client_secret = client_secret
    @client.authorization.scope = oauth_scope
    @client.authorization.redirect_uri = redirect_uri

    uri = @client.authorization.authorization_uri
    Launchy.open(uri)

    # Exchange authorization code for access token
    $stdout.write 'Enter authorization code: '
    @client.authorization.code = gets.chomp
    @client.authorization.fetch_access_token!
  end

  def txt_url(file_path)
    # Insert a file
    file = @drive.files.insert.request_schema.new({
                                                    title: file_path,
                                                    description: 'A test resume document',
                                                  })

    mime = MIME::Types.type_for(file_path).first.to_s
    media = Google::APIClient::UploadIO.new(file_path, mime)

    needs_ocr = mime == 'application/pdf'

    result = @client.execute(
      :api_method => @drive.files.insert,
      :body_object => file,
      :media => media,
      :parameters => {
        'uploadType' => 'multipart',
        convert: true,
        ocr: (true if needs_ocr),
        ocrLanguage: (:en if needs_ocr),
        useContentAsIndexableText: (true if needs_ocr),
        'alt' => 'json'}.reject{ |k,v| v.nil? })

    # Pretty print the API result
    jj result.data.to_hash

    file_id = result.data.id

    result = @client.execute(
      :api_method => @drive.files.get,
      :parameters => {'fileId' => file_id})

    if result.status == 200
      result.data.export_links['text/plain']
    else
      puts "An error occurred: #{result.data['error']['message']}"
    end

  end

end
