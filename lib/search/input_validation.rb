class InputError < StandardError
end

module InputValidation
  VALID_DATA_SOURCES = ['organizations', 'tickets', 'users']
  VALID_SEARCH_EXAMPLE = "search <#{VALID_DATA_SOURCES.join('|')}> <attribute>:<value>"

  def self.validate_data_source(data_source)
    if !data_source
      raise InputError, "No data source specified. Try: `#{VALID_SEARCH_EXAMPLE}`"
    end
    
    if !VALID_DATA_SOURCES.include?(data_source)
      raise InputError, "`#{data_source}` is not a valid data source. Try: `#{VALID_SEARCH_EXAMPLE}`"
    end
  end
  
  def self.validate_attribute_value(attribute_value)
    if !attribute_value
      raise InputError, "No data source specified. Try: `#{VALID_SEARCH_EXAMPLE}`"
    end
  
    if !(/^.+:.*$/.match?(attribute_value))
      raise InputError, "`#{attribute_value} is not a valid search format. Try: `#{VALID_SEARCH_EXAMPLE}``"
    end
  end
end