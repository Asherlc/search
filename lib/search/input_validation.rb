class InputError < StandardError
end

# Validations methods for string input
module InputValidation
  VALID_DATA_SOURCES = %w[organizations tickets users].freeze
  VALID_SEARCH_EXAMPLE = "search <#{VALID_DATA_SOURCES.join('|')}> <attribute>:<value>".freeze

  def self.validate_data_source(data_source)
    raise InputError, "No data source specified. Try: `#{VALID_SEARCH_EXAMPLE}`" unless data_source
    raise InputError, "`#{data_source}` is not a valid data source. Try: `#{VALID_SEARCH_EXAMPLE}`" unless VALID_DATA_SOURCES.include?(data_source)
  end

  def self.validate_attribute_value(attribute_value)
    raise InputError, "No data source specified. Try: `#{VALID_SEARCH_EXAMPLE}`" unless attribute_value
    raise InputError, "`#{attribute_value} is not a valid search format. Try: `#{VALID_SEARCH_EXAMPLE}``" unless /^.+:.*$/.match?(attribute_value)
  end
end
