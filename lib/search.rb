#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './search/searcher'
require_relative './search/serializer'
require_relative './search/input_validation'

def search(data_source, attribute_value)
  InputValidation.validate_data_source(data_source)
  InputValidation.validate_attribute_value(attribute_value)

  attribute, value = attribute_value.split(':')

  results = Searcher.instance.perform(data_source, attribute, value)

  results.each do |model|
    puts Serializer.new(model, data_source).to_s
  end
end
