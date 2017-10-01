require_relative './searcher'

class Serializer
  def initialize(model, data_source, include_relationships = true)
    if !model.is_a?(Hash)
      raise "Model must be a hash, not #{model.inspect}"
    end

    @include_relationships = include_relationships
    @model = model
    @data_source = data_source
  end

  def to_s
    model_with_relationships.inject('') do |string, (key, value)|
      if !@include_relationships && relationship_to_data_source(key)
        next string
      end

      string << serialize_attribute(key, value)
      string << "\n"
    end
  end

  private

  def serialize_attribute(key, value)
    if value.respond_to?(:each)
      serialize_iterable(key, value)
    else
      "#{key}: #{value.to_s}"
    end
  end

  def serialize_iterable(key, value)
    to_indent = nil
    data_source = relationship_to_data_source(key)

    if data_source && value.is_a?(Array)
      to_indent = value.collect do |related_model|
        Serializer.new(related_model, data_source, false).to_s
      end.join("\n")
    elsif data_source
      to_indent = Serializer.new(value, data_source, false).to_s
    else
      to_indent = value.join(', ')
    end

    indented = to_indent ? indent(to_indent) : ''

    "#{key}:\n#{indented}"
  end

  def indent(string)
    string.gsub(/([^\n]*)(\n|$)/) do |match|
      last_iteration = ($1 == "" && $2 == "")
      line = ""
      line << ('-- ') unless last_iteration
      line << $1
      line << $2
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
    when 'organizations'
    when 'tickets'
      with_relationships['submitter'] = Searcher.instance.perform('users', '_id', @model['submitter_id'])[0]
      with_relationships['assignee'] = Searcher.instance.perform('users', '_id', @model['assignee_id'])[0]
      with_relationships['organization'] = Searcher.instance.perform('organizations', '_id', @model['organization_id'])[0]
    when 'users'
      with_relationships['organization'] = Searcher.instance.perform('organizations', '_id', @model['organization_id'])[0]
      with_relationships['tickets'] = Searcher.instance.perform('tickets', 'submitter_id', @model['_id']) + Searcher.instance.perform('tickets', 'assignee_id', @model['_id'])
    end

    with_relationships
  end
end