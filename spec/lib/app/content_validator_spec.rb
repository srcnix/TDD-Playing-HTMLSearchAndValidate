require_relative '../../spec_helper'

describe ContentValidator do
  before(:all) do
    @content_validator = ContentValidator.new
  end

  context '#initialize' do
    it 'should use W3CMarkup as default #validator' do
      expect(@content_validator.validator).to be_a(Validators::W3CMarkup)
    end
  end

  context '#validate_content(content)' do
    it 'should throw an exception if no content is provided' do
      expect {
        @content_validator.validate_content
      }.to raise_exception(ArgumentError)
    end

    it 'should call #validate_content on #validator' do
      expect(@content_validator.validator).to receive(:validate_content)

      @content_validator.validate_content('Content...')
    end
  end

  context '#validator=(validator)' do
    it 'should throw an exception if validator is not defined' do
      expect {
        ContentValidator.new(validator: 'Example')
      }.to raise_exception(ContentValidator::Exception, 'Validators::Example undefined')
    end
  end
end
