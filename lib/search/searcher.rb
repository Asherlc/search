require 'singleton'
require 'json'

# Singleton class to perform a search across a data set
class Searcher
  include Singleton

  def perform(data_source, attribute, value)
    data[data_source.to_sym].select do |model|
      match?(model, attribute, value, data_source)
    end
  end

  private

  def match?(model, attribute, value, _data_source)
    model_value = model[attribute]

    if empty?(value) && empty?(model_value)
      true
    elsif empty?(value) || empty?(model_value)
      false
    elsif model_value.to_s == value.to_s
      true
    elsif model_value.respond_to?(:include?) && model_value.include?(value)
      true
    else
      false
    end
  end

  def empty?(value)
    value.nil? || value == ''
  end

  def data
    @data ||= {
      organizations: raw_data_for('organizations'),
      tickets: raw_data_for('tickets'),
      users: raw_data_for('users')
    }
  end

  def data_directory
    File.expand_path('../../data', File.dirname(__FILE__))
  end

  def file_path_for(data_source)
    File.join(data_directory, "#{data_source}.json")
  end

  def raw_data_for(data_source)
    json = File.read(file_path_for(data_source))

    JSON.parse(json)
  end
end
