require_relative '../../spec_helper'

describe SearchLinks do
  before(:all) do
    @search_links = SearchLinks.new
    @query        = 'Ruby'
  end

  context '#initialize' do
    it 'should use Google as default #search_engine' do
      expect(@search_links.search_engine).to be_a(SearchEngines::Google)
    end
  end

  context '#get_first_link_content_for(query)' do
    it 'should throw an exception if no query is provided' do
      expect {
        @search_links.get_first_link_content_for
      }.to raise_exception(ArgumentError)
    end

    it 'should call #get_first_link_for for first link' do
      expect(@search_links).to receive(:get_first_link_for).with(@query).and_call_original

      @search_links.get_first_link_content_for(@query)
    end

    it 'should call #get_content_for_link on search_engine' do
      expect(@search_links).to receive(:get_content_for_link)

      @search_links.get_first_link_content_for(@query)
    end

    it 'should return the HTML content for link' do
      content = @search_links.get_first_link_content_for(@query)

      expect(content).to be_a(String)
    end
  end

  context '#get_content_for_link(link)' do
    before(:all) do
      @link = @search_links.get_links_for('Ruby').first
    end

    it 'should throw an exception if no link is provided' do
      expect {
        @search_links.get_content_for_link
      }.to raise_exception(ArgumentError)
    end

    it 'should call #get_content_for_link on SearchEngine' do
      expect(@search_links.search_engine).to receive(:get_content_for_link).with(@link)

      @search_links.get_content_for_link(@link)
    end

    it 'should return the HTML content for link' do
      content = @search_links.get_content_for_link(@link)

      expect(content).to be_a(String)
    end
  end

  context '#get_first_link_for(query)' do
    it 'should throw an exception if no query is provided' do
      expect {
        @search_links.get_first_link_for
      }.to raise_exception(ArgumentError)
    end

    it 'should call #get_links_for' do
      expect(@search_links).to receive(:get_links_for).with(@query).and_call_original

      @search_links.get_first_link_content_for(@query)
    end

    it 'should return a single link' do
      expect(@search_links.get_first_link_for(@query)).to be_a(Mechanize::Page::Link)
    end
  end

  context '#get_links_for(query)' do
    it 'should throw an exception if no query is provided' do
      expect {
        @search_links.get_links_for
      }.to raise_exception(ArgumentError)
    end

    it 'should call #get_links_for on SearchEngine' do
      expect(@search_links.search_engine).to receive(:get_links_for).with(@query)

      @search_links.get_links_for(@query)
    end

    it 'should return an Array' do
      expect(@search_links.get_links_for(@query)).to be_a(Array)
    end
  end

  context '#search_engine=(engine)' do
    it 'should throw an exception if engine is not defined' do
      expect {
        SearchLinks.new(search_engine: 'Yahoo')
      }.to raise_exception(SearchLinks::Exception, 'SearchEngines::Yahoo undefined')
    end
  end
end
