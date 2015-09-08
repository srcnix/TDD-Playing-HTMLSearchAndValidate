require_relative '../../../spec_helper'

describe SearchEngines::Base do
  before(:all) do
    @user_agent = SearchEngines::Base::USER_AGENT
    @engine     = SearchEngines::Base.new
  end

  context '#initialize' do
    it 'should initialize an instance of Mechanize' do
      expect(Mechanize).to receive(:new).and_call_original

      SearchEngines::Base.new
    end

    it 'should set a user_agent for Mechanize' do
      expect(@engine.agent.user_agent).to eql(@user_agent)
    end
  end

  context '#get_content_for_link(link)' do
    before(:all) do
      uri   = URI('https://www.google.co.uk/search?sclient=psy-ab&site=&source=hp&q=Ruby>')
      page  = Mechanize::Page.new(uri)
      
      @link = Mechanize::Page::Link.new('https://www.ruby-lang.org/en/', @engine.agent, page)
    end

    it 'should throw an exception if no link is provided' do
      expect {
        @engine.get_content_for_link
      }.to raise_exception(ArgumentError)
    end

    it 'should visit link' do
      expect(@link).to receive(:click).and_call_original

      @engine.get_content_for_link(@link)
    end

    it 'should return the HTML content for link' do
      content = @engine.get_content_for_link(@link)

      expect(content).to be_a(String)
    end
  end

  context '#agent' do
    it 'should return an instance of Mechanize' do
      expect(@engine.agent).to be_a(Mechanize)
    end
  end
end
