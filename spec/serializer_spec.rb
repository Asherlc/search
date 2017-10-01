require_relative '../lib/search/serializer'

RSpec.describe Serializer do
  before(:each) do
    test_data_directory = File.expand_path('./data', File.dirname(__FILE__))
    allow(Searcher.instance).to receive(:data_directory).and_return(test_data_directory)
  end

  Searcher.instance

  let(:organization_101) do
    {
      '_id' => 101,
      'url' => 'http://initech.zendesk.com/api/v2/organizations/101.json',
      'external_id' => '9270ed79-35eb-4a38-a46f-35725197ea8d',
      'name' => 'Enthaze',
      'domain_names' => [
        'kage.com',
        'ecratic.com',
        'endipin.com',
        'zentix.com'
      ],
      'created_at' => '2016-05-21T11:10:28 -10:00',
      'details' => '',
      'shared_tickets' => false,
      'tags' => %w[
        Fulton
        West
        Rodriguez
        Farley
        Trevino
      ]
    }
  end

  let(:ticket) do
    {
      '_id' => '436bf9b0-1147-4c0a-8439-6f79833bff5b',
      'url' => 'http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json',
      'external_id' => '9210cdc9-4bee-485f-a078-35396cd74063',
      'created_at' => '2016-04-28T11:19:34 -10:00',
      'type' => 'incident',
      'subject' => 'A Catastrophe in Korea (North)',
      'description' => 'Nostrud ad sit velit cupidatat laboris ipsum nisi amet laboris ex exercitation amet et proident. Ipsum fugiat aute dolore tempor nostrud velit ipsum.',
      'priority' => 'high',
      'status' => 'pending',
      'submitter_id' => 38,
      'assignee_id' => 24,
      'organization_id' => 101,
      'tags' => [
        'Ohio',
        'Pennsylvania',
        'American Samoa',
        'Northern Mariana Islands'
      ],
      'has_incidents' => false,
      'due_at' => '2016-07-31T02:37:50 -10:00',
      'via' => 'web'
    }
  end

  subject do
    Serializer.new(organization_101, 'organizations')
  end

  describe '#to_s' do
    it 'returns the result in a list' do
      expect(subject.to_s).to eq <<~END
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
      END
    end

    context 'with a related record' do
      it 'returns the result in a table with the relationships' do
        expect(Serializer.new(ticket, 'tickets').to_s).to eq <<~END
        _id: 436bf9b0-1147-4c0a-8439-6f79833bff5b
        url: http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json
        external_id: 9210cdc9-4bee-485f-a078-35396cd74063
        created_at: 2016-04-28T11:19:34 -10:00
        type: incident
        subject: A Catastrophe in Korea (North)
        description: Nostrud ad sit velit cupidatat laboris ipsum nisi amet laboris ex exercitation amet et proident. Ipsum fugiat aute dolore tempor nostrud velit ipsum.
        priority: high
        status: pending
        submitter_id: 38
        assignee_id: 24
        organization_id: 101
        tags:
        -- Ohio, Pennsylvania, American Samoa, Northern Mariana Islands
        has_incidents: false
        due_at: 2016-07-31T02:37:50 -10:00
        via: web
        submitter:
        -- _id: 38
        -- url: http://initech.zendesk.com/api/v2/users/38.json
        -- external_id: 72c7ba23-e070-4583-b701-04a038a28b02
        -- name: Elma Castro
        -- alias: Mr Georgette
        -- created_at: 2016-01-31T02:46:05 -11:00
        -- active: false
        -- verified: false
        -- shared: true
        -- locale: en-AU
        -- timezone: Gibraltar
        -- last_login_at: 2012-12-20T01:48:00 -11:00
        -- email: georgettecastro@flotonic.com
        -- phone: 8364-062-708
        -- signature: Don't Worry Be Happy!
        -- organization_id: 114
        -- tags:
        -- -- Colton, Williamson, Marshall, Charco
        -- suspended: true
        -- role: agent
        
        assignee:
        -- _id: 24
        -- url: http://initech.zendesk.com/api/v2/users/24.json
        -- external_id: c01c2b7a-30cd-41d1-98e7-2cdd42d55d84
        -- name: Harris Côpeland
        -- alias: Miss Gates
        -- created_at: 2016-03-02T03:35:41 -11:00
        -- active: false
        -- verified: false
        -- shared: false
        -- locale: zh-CN
        -- timezone: Cameroon
        -- last_login_at: 2013-05-11T10:41:04 -10:00
        -- email: gatescopeland@flotonic.com
        -- phone: 9855-882-406
        -- signature: Don't Worry Be Happy!
        -- organization_id: 110
        -- tags:
        -- -- Kieler, Swartzville, Salvo, Guthrie
        -- suspended: false
        -- role: agent
        
        organization:
        -- _id: 101
        -- url: http://initech.zendesk.com/api/v2/organizations/101.json
        -- external_id: 9270ed79-35eb-4a38-a46f-35725197ea8d
        -- name: Enthaze
        -- domain_names:
        -- -- kage.com, ecratic.com, endipin.com, zentix.com
        -- created_at: 2016-05-21T11:10:28 -10:00
        -- details: 
        -- shared_tickets: false
        -- tags:
        -- -- Fulton, West, Rodriguez, Farley, Trevino

      END
      end
    end
  end
end
