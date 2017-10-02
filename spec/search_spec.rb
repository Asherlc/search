# frozen_string_literal: true

require_relative '../lib/search'

RSpec.describe 'search' do
  before(:each) do
    test_data_directory = File.expand_path('./data', File.dirname(__FILE__))
    allow(Searcher.instance).to receive(:data_directory).and_return(test_data_directory)
  end

  # rubocop:disable Layout/TrailingWhitespace
  organization_101_serialized = <<~STRING
    _id: 101
    url: http://initech.zendesk.com/api/v2/organizations/101.json
    external_id: 9270ed79-35eb-4a38-a46f-35725197ea8d
    name: Enthaze
    domain_names:
    -- kage.com, ecratic.com, endipin.com, zentix.com
    created_at: 2016-05-21T11:10:28 -10:00
    details: 
    shared_tickets: false
    tags:
    -- Fulton, West, Rodriguez, Farley, Trevino
STRING

  organization_102_serialized = <<~STRING
    _id: 102
    url: http://initech.zendesk.com/api/v2/organizations/102.json
    external_id: 7cd6b8d4-2999-4ff2-8cfd-44d05b449226
    name: Nutralab
    domain_names:
    -- trollery.com, datagen.com, bluegrain.com, dadabase.com
    created_at: 2016-04-07T08:21:44 -10:00
    details: Non profit
    shared_tickets: true
    tags:
    -- Cherry, Collier, Fuentes, Trevino
STRING

  context 'with one matching model' do
    it 'outputs the results to stdout' do
      expect { search('organizations', '_id:101') }.to output(organization_101_serialized).to_stdout
    end
  end

  context 'with multiple matching models' do
    it 'outputs the results to stdout' do
      expect { search('organizations', 'tags:Trevino') }.to output("#{organization_101_serialized}#{organization_102_serialized}").to_stdout
    end
  end

  context 'with invalid data source' do
    it 'raises an error' do
      expect { search('org', '_id:101') }.to raise_error(InputError)
    end
  end

  context 'with invalid attribute value string' do
    it 'raises an error' do
      expect { search('org', '_id101') }.to raise_error(InputError)
    end
  end
end
