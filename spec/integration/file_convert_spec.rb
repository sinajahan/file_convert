describe FileConvert do
  before(:all) do
    upload_fixtures_to_s3
    @converter = FileConvert::Converter.new load_config
  end

  describe 'return text content' do
    it 'from a docx file' do
      docx = @converter.to_txt_from_s3 'justin.docx'
      expected = IO.read('./spec/fixtures/justin.txt')
      docx.force_encoding('UTF-8').should == expected
    end

    it 'from a pdf file' do
      pdf = @converter.to_txt_from_s3 'jane.pdf'
      expected = IO.read('./spec/fixtures/jane.txt')
      pdf.force_encoding('UTF-8').should == expected
    end

    it 'from a doc file' do
      doc = @converter.to_txt_from_s3 'james.doc'
      expected = IO.read('./spec/fixtures/james.txt')
      doc.force_encoding('UTF-8').should == expected
    end
  end

  after(:all) do
    remove_fixtures_from_s3
  end
end