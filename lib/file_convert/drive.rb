require 'google/api_client'
require 'launchy'
require 'yaml'
require 'mime/types'

module FileConvert
  class Drive
    def initialize(config)
      @client = authenticate config
      @drive = @client.discovered_api('drive', 'v2')
    end

    def authenticate(config)
      key = Google::APIClient::PKCS12.load_key(config.drive_key_path, 'notasecret')
      asserter = Google::APIClient::JWTAsserter.new(config.drive_service_account,
                                                    'https://www.googleapis.com/auth/drive', key)
      client = Google::APIClient.new
      client.authorization = asserter.authorize()
      client
    end

    def get_txt(file_path)
      file_id = upload file_path
      txt_url = get_txt_url file_id
      download txt_url
    end


    #file = @drive.files.insert.request_schema.new({
    #                                                  title: file_path,
    #                                                  description: 'A test resume document',
    #                                                })
    #
    #  mime = MIME::Types.type_for(file_path).first.to_s
    #  media = Google::APIClient::UploadIO.new(file_path, mime)
    #
    #  needs_ocr = mime == 'application/pdf'
    #
    #  result = @client.execute(
    #    :api_method => @drive.files.insert,
    #    :body_object => file,
    #    :media => media,
    #    :parameters => {
    #      'uploadType' => 'multipart',
    #      convert: true,
    #      ocr: (true if needs_ocr),
    #      ocrLanguage: (:en if needs_ocr),
    #      useContentAsIndexableText: (true if needs_ocr),
    #      'alt' => 'json'}.reject { |k, v| v.nil? })
    #
    #  raise "Failed to upload #{file_path} to google drive #{result.data.inspect}" if result.data.id.nil?
    #
    #  file_id = result.data.id
    #
    #  result = @client.execute(
    #    :api_method => @drive.files.get,
    #    :parameters => {'fileId' => file_id})
    #
    #  result.data.export_links['text/plain']

    private

    def download(url)
      result = @client.execute(:uri => url)
      if result.status == 200
        return result.body
      else
        puts "An error occurred: #{result.data['error']['message']}"
        return nil
      end
    end

    def get_txt_url(file_id)
      result = @client.execute(
        :api_method => @drive.files.get,
        :parameters => {'fileId' => file_id})

      raise "Failed to get file metadata: #{result.data['error']['message']}" unless result.status == 200
      raise "Failed to convert correctly #{file_id}" unless result.data.export_links

      result.data.export_links['text/plain']
    end

    def upload(file_path)
      drive = @client.discovered_api('drive', 'v2')

      mime_type = MIME::Types.type_for(file_path).first.to_s
      file = drive.files.insert.request_schema.new({
                                                     'title' => file_path,
                                                     'mimeType' => mime_type
                                                   })
      media = Google::APIClient::UploadIO.new(file_path, mime_type)

      needs_ocr = mime_type == 'application/pdf'

      result = @client.execute(
        :api_method => drive.files.insert,
        :body_object => file,
        :media => media,
        :parameters => {
          'uploadType' => 'multipart',
          convert: true,
          ocr: (true if needs_ocr),
          ocrLanguage: (:en if needs_ocr),
          useContentAsIndexableText: (true if needs_ocr),
          'alt' => 'json'}.reject { |k, v| v.nil? })

      raise "Failed to upload #{file_path} to google drive: #{result.data['error']['message']}" unless result.status == 200
      result.data.id
    end
  end
end