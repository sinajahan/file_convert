require 'google/api_client'
require 'launchy'
require 'yaml'
require 'mime/types'

class FileConvert::Drive
  def initialize(config)
    # Get your credentials from the APIs Console
    client_id = config.client_id
    client_secret = config.client_secret
    oauth_scope = config.oauth_scope
    redirect_uri = config.redirect_uri

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
    @client.authorization.code = $stdin.gets.chomp
    @client.authorization.fetch_access_token!
  end

  def get_convert_txt_url(file_path)
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

    file_id = result.data.id

    result = @client.execute(
      :api_method => @drive.files.get,
      :parameters => {'fileId' => file_id})

    result.data.export_links['text/plain']
  end

end
