#!/usr/bin/env ruby
require_relative './lib/searcher'
require_relative './lib/serializer'
require_relative './lib/input_validation'

data_source = ARGV[0]
attribute_value = ARGV[1]

InputValidation.validate_data_source(data_source)
InputValidation.validate_attribute_value(attribute_value)

attribute, value = ARGV[1].split(':')

results = Searcher.instance.perform(data_source, attribute, value)

results.each do |model|
  puts Serializer.new(models, data_source).to_table
end