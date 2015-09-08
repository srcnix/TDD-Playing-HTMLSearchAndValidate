$:.unshift File.expand_path('../../lib', __FILE__)

require 'app'
require 'optparse'

options = {}

optparse = OptionParser.new do |opts|
  opts.on('-q', '--query QUERY', 'The query to search') do |value|
    options[:query] = value
  end

  opts.on('-s', '--search-engine ENGINE', 'The search engine to search against') do |value|
    options[:search_engine] = value
  end

  opts.on('-v', '--validator VALIDATOR', 'The validator to validate against') do |value|
    options[:validator] = value
  end
end

optparse.parse!

options[:query]         ||= 'Ruby programming language'
options[:search_engine] ||= 'Google'
options[:validator]     ||= 'W3CMarkup'

query             = options[:query]
search_engine     = options[:search_engine]
validator         = options[:validator]
search_links      = SearchLinks.new(search_engine: search_engine)
content_validator = ContentValidator.new(validator: validator)

content           = search_links.get_first_link_content_for(query)
validate_response = content_validator.validate_content(content)
valid             = (validate_response[:valid]) ? 'yes' : 'no'

puts "Query: \t\t#{query}"
puts "Search engine: \t#{search_engine}"
puts "Validator: \t#{validator}"
puts "Valid: \t\t#{valid}"

puts 'Messages:'
validate_response[:messages].each do |message|
  puts "- #{message['type']}: \t#{message['message']}"
end
