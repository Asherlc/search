require_relative './searcher'

class Serializer
  def initialize(model, data_source)
    @model = model
    @data_source = data_source
  end

  def to_s
    model_with_relationships.to_s
  end

  def model_with_relationships
    with_relationships = @model.dup

    case @data_source
    when 'organizations'
    when 'tickets'
      with_relationships['submitter'] = Searcher.instance.perform('users', '_id', model['submitter_id'])[0]
      with_relationships['assignee'] = Searcher.instance.perform('users', '_id', model['assignee_id'])[0]
      with_relationships['organization'] = Searcher.instance.perform('organizations', '_id', model['organization_id'])[0]
    when 'users'
      with_relationships['organization'] = Searcher.instance.perform('organizations', '_id', model['organization_id'])[0]
      with_relationships['tickets'] = [
        Searcher.instance.perform('tickets', 'submitter_id', model['_id'])[0],
        Searcher.instance.perform('tickets', 'assignee_id', model['_id'])[0]
      ]
    end

    with_relationships
  end
end