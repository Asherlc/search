# frozen_string_literal: true

require_relative './searcher'

# Serialize any given model and its associations
class Serializer
  def initialize(model, data_source, include_relationships = true)
    raise "Model must be a hash, not #{model.inspect}" unless model.is_a?(Hash)

    @include_relationships = include_relationships
    @model = model
    @data_source = data_source
  end

  def to_s
    model_with_relationships.inject('') do |string, (key, value)|
      next string if !@include_relationships && relationship_to_data_source(key)

      string += serialize_attribute(key, value)
      string + "\n"
    end
  end

  private

  def serialize_attribute(key, value)
    if value.respond_to?(:each)
      serialize_iterable(key, value)
    else
      "#{key}: #{value}"
    end
  end

  def serialize_iterable(key, value)
    data_source = relationship_to_data_source(key)

    to_indent = if data_source && value.is_a?(Array)
                  value.collect do |related_model|
                    Serializer.new(related_model, data_source, false).to_s
                  end.join("\n")
                elsif data_source
                  Serializer.new(value, data_source, false).to_s
                else
                  value.join(', ')
                end

    indented = to_indent ? indent(to_indent) : ''

    "#{key}:\n#{indented}"
  end

  def indent(string)
    string.gsub(/([^\n]*)(\n|$)/) do |_match|
      last_iteration = (Regexp.last_match(1) == '' && Regexp.last_match(2) == '')
      line = ''
      line += '-- ' unless last_iteration
      line += Regexp.last_match(1)
      line += Regexp.last_match(2)
      line
    end
  end

  def relationship_to_data_source(relationship)
    case relationship
    when 'submitter', 'assignee'
      'users'
    when 'organization'
      'organizations'
    when 'tickets'
      'tickets'
    end
  end

  def model_with_relationships
    with_relationships = @model.dup

    case @data_source
    when 'organizations' then
      # No relationships to add
    when 'tickets' then
      with_relationships['submitter'] = Searcher.instance.perform('users', '_id', @model['submitter_id'])[0]
      with_relationships['assignee'] = Searcher.instance.perform('users', '_id', @model['assignee_id'])[0]
      with_relationships['organization'] = Searcher.instance.perform('organizations', '_id', @model['organization_id'])[0]
    when 'users' then
      with_relationships['organization'] = Searcher.instance.perform('organizations', '_id', @model['organization_id'])[0]
      with_relationships['tickets'] = Searcher.instance.perform('tickets', 'submitter_id', @model['_id']) + Searcher.instance.perform('tickets', 'assignee_id', @model['_id'])
    end

    with_relationships
  end
end
