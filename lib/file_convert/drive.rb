require 'google/api_client'
require 'launchy'
require 'yaml'
require 'mime/types'

module FileConvert
  class Drive
    def initialize(key_path, service_account)
      create_client(key_path, service_account)
      @drive = @client.discovered_api('drive', 'v2')
    end

    def get_txt(file_path)
      mime_type = MIME::Types.type_for(file_path).first.to_s
      return IO.read file_path if mime_type == 'text/plain'
      file_id = upload file_path
      txt_url = get_txt_url file_id
      content = download txt_url
      delete_file file_id
      content
    end

    private

    def delete_file(file_id)
      result = @client.execute(
        :api_method => @drive.files.delete,
        :parameters => { 'fileId' => file_id })
      raise TransientError,
            "Failed to delete the file #{file_id} from google drive #{result.data['error']['message']}" unless result.status == 204
    end

    def create_client(key_path, service_account)
      key = Google::APIClient::PKCS12.load_key(key_path, 'notasecret')
      asserter = Google::APIClient::JWTAsserter.new(service_account,
                                                    'https://www.googleapis.com/auth/drive', key)
      @client = Google::APIClient.new
      @client.authorization = asserter.authorize()
    end


    def download(url)
      result = @client.execute(:uri => url)
      raise TransientError,
            "Failed to download #{url}" unless result.status == 200
      result.body
    end

    def get_txt_url(file_id)
      result = @client.execute(
        :api_method => @drive.files.get,
        :parameters => {'fileId' => file_id})

      raise TransientError,
            "Failed to get file metadata: #{result.data['error']['message']}" unless result.status == 200
      raise TransientError,
            "Failed to convert correctly #{file_id}" unless result.data.export_links

      result.data.export_links['text/plain']
    end

    def upload(file_path)
      mime_type = MIME::Types.type_for(file_path).first.to_s
      file = @drive.files.insert.request_schema.new({
                                                     'title' => file_path,
                                                     'mimeType' => mime_type
                                                   })
      media = Google::APIClient::UploadIO.new(file_path, mime_type)

      execute_params = {
        :api_method => @drive.files.insert,
        :body_object => file,
        :media => media,
        :parameters => {
          'uploadType' => 'multipart',
          convert: true,
          'alt' => 'json'}
      }

      if mime_type == 'application/pdf'
        execute_params[:parameters].merge!(ocr: true, ocrLanguage: :en, useContentAsIndexableText: true)
      end

      result = @client.execute(execute_params)

      raise TransientError,
            "Failed to upload #{file_path} to google drive: #{result.data['error']['message']}" unless result.status == 200
      result.data.id
    end
  end
end