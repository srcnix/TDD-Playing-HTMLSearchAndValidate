require_relative '../spec_helper'

describe 'bin/first_link_validator' do
  before(:all) do
    @bin_path = File.expand_path('../../../bin/first_link_validator.rb', __FILE__)
  end

  it 'should add lib dir to load path' do
    load_path = File.expand_path('../../../lib', __FILE__)

    surpress_puts do
      load @bin_path
    end

    expect($:).to include(load_path)
  end

  it 'should initialize SearchLinks' do
    expect(SearchLinks).to receive(:new).and_call_original

    surpress_puts { load @bin_path }
  end

  it 'should initialize ContentValidator' do
    expect(ContentValidator).to receive(:new).and_call_original

    surpress_puts { load @bin_path }
  end

  it 'should call #get_first_link_content_for on SearchLinks' do
    expect_any_instance_of(SearchLinks).to receive(:get_first_link_content_for).and_call_original

    surpress_puts { load @bin_path }
  end

  it 'should call #validate_content on ContentValidator' do
    expect_any_instance_of(ContentValidator).to receive(:validate_content).and_call_original

    surpress_puts { load @bin_path }
  end

  it 'should output expected data' do
    stdout, stderr  = capture("ruby #{@bin_path}")
    expected_output = "Query: \t\tRuby programming language\n"+
                      "Search engine: \tGoogle\n"+
                      "Validator: \tW3CMarkup\n"+
                      "Valid: \t\tno"

    expect(stdout).to match(expected_output)
  end

  context 'passing query' do
    before(:all) do
      @query            = 'Example query'
      @expected_output  = "Query: \t\t#{@query}\n"
    end

    it 'should be possible with -q' do
      stdout, stderr = capture("ruby #{@bin_path} -q '#{@query}'")

      expect(stdout).to match(@expected_output)
    end

    it 'should be possible with --query' do
      stdout, stderr = capture("ruby #{@bin_path} --query '#{@query}'")

      expect(stdout).to match(@expected_output)
    end
  end

  context 'passing search_engine' do
    before(:all) do
      @search_engine    = 'Google'
      @expected_output  = "Search engine: \t#{@search_engine}\n"
    end

    it 'should be possible with -s' do
      stdout, stderr = capture("ruby #{@bin_path} -s '#{@search_engine}'")

      expect(stdout).to match(@expected_output)
    end

    it 'should be possible with --search-engine' do
      stdout, stderr = capture("ruby #{@bin_path} --search-engine '#{@search_engine}'")

      expect(stdout).to match(@expected_output)
    end

    it 'should throw an exception if search_engine is not valid' do
      stdout, stderr = capture("ruby #{@bin_path} -s 'Yahoo'")

      expect(stderr).to match('SearchEngines::Yahoo undefined')
    end
  end

  context 'passing validator' do
    before(:all) do
      @validator        = 'W3CMarkup'
      @expected_output  = "Validator: \t#{@validator}\n"
    end

    it 'should be possible with -v' do
      stdout, stderr = capture("ruby #{@bin_path} -v '#{@validator}'")

      expect(stdout).to match(@expected_output)
    end

    it 'should be possible with --validator' do
      stdout, stderr = capture("ruby #{@bin_path} --validator '#{@validator}'")

      expect(stdout).to match(@expected_output)
    end

    it 'should throw an exception if validator is not valid' do
      stdout, stderr = capture("ruby #{@bin_path} -v 'SomeOther'")

      expect(stderr).to match('Validators::SomeOther undefined')
    end
  end

  def capture(command)
    require 'open3'

    stdout_str = ""
    stderr_str = ""

    Open3.popen3(command.to_s) do |stdin, stdout, stderr, thread|
      stdout_str += stdout.read
      stderr_str += stderr.read
    end

    [stdout_str, stderr_str]
  end

  def surpress_puts
    @original_stderr  = $stderr
    @original_stdout  = $stdout
    $stderr           = StringIO.new
    $stdout           = StringIO.new

    yield

    $stderr           = @original_stderr
    $stdout           = @original_stdout
    @original_stderr  = nil
    @original_stdout  = nil
  end
end
