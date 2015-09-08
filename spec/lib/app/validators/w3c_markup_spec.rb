require_relative '../../../spec_helper'

describe Validators::W3CMarkup do
  before(:all) do
    @validator        = Validators::W3CMarkup.new
    @valid_content    = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" '+
                        '"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">'+
                        '<html><head><title>Title</title></head><body></body></html>'
    @invalid_content  = '<html><body></body></html>'
  end

  it 'should extend Validators::Base' do
    expect(Validators::W3CMarkup.ancestors).to include(Validators::Base)
  end

  context '#validate_content(content)' do
    it 'should throw an exception if no content is provided' do
      expect {
        @validator.validate_content
      }.to raise_exception(ArgumentError)
    end

    it 'should POST to https://validator.w3.org/nu/' do
      expect(@validator.agent).to receive(:post).with(
        'https://validator.w3.org/nu/?out=json',
        @valid_content,
        {
          'Content-type' => 'text/html; charset=utf-8'
        }
      ).and_call_original

      @validator.validate_content(@valid_content)
    end

    it 'should parse the JSON response' do
      expect(JSON).to receive(:parse).and_call_original

      @validator.validate_content(@valid_content)
    end

    it 'should return a Hash with validity as true for valid content' do
      response = @validator.validate_content(@valid_content)

      expect(response[:valid]).to eql(true)
    end

    it 'should return a Hash with validity as false with messages for invalid content' do
      response = @validator.validate_content(@invalid_content)

      expect(response[:valid]).to eql(false)
      expect(response[:messages]).to be_a(Array)
    end
  end
end
