#!/usr/bin/env ruby
require_relative './search/searcher'
require_relative './search/serializer'
require_relative './search/input_validation'

data_source = ARGV[0]
attribute_value = ARGV[1]

InputValidation.validate_data_source(data_source)
InputValidation.validate_attribute_value(attribute_value)

attribute, value = ARGV[1].split(':')

results = Searcher.instance.perform(data_source, attribute, value)

results.each do |model|
  puts Serializer.new(model, data_source).to_s
end
