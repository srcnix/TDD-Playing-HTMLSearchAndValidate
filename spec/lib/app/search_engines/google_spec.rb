require_relative '../../../spec_helper'

describe SearchEngines::Google do
  before(:all) do
    @engine = SearchEngines::Google.new
    @query  = 'Ruby'
  end

  it 'should extend SearchEngines::Base' do
    expect(SearchEngines::Google.ancestors).to include(SearchEngines::Base)
  end

  context '#get_links_for(query)' do
    it 'should call #search with query' do
      expect(@engine).to receive(:search).with(@query).and_call_original

      @engine.get_links_for(@query)
    end

    it 'should return an array of Mechanize::Page::Link' do
      links = @engine.get_links_for(@query)

      links.each do |link|
        expect(link).to be_a(Mechanize::Page::Link)
        expect(link.uri.to_s).to match(/https?:\/\//)
      end

      expect(links).to be_a(Array)
    end
  end

  context '#search(query)' do
    it 'should throw an exception if no query is provided' do
      expect {
        @engine.get_links_for
      }.to raise_exception(ArgumentError)
    end

    context '#agent' do
      it 'should search Google.com' do
        expect(@engine.agent).to receive(:get).with('https://www.google.com').and_call_original
        expect_any_instance_of(Mechanize::Page).to receive(:form).and_call_original
        expect_any_instance_of(Mechanize::Form).to receive(:field_with).with(name: 'q').and_call_original
        expect_any_instance_of(Mechanize::Form).to receive(:button_with).with(name: 'btnG').and_call_original
        expect_any_instance_of(Mechanize::Form::Text).to receive(:value=).with(@query)
        expect_any_instance_of(Mechanize::Form).to receive(:submit)

        @engine.search(@query)
      end

      it 'should return an instance of Mechanize::Page' do
        expect(@engine.search(@query)).to be_a(Mechanize::Page)
      end
    end
  end
end
