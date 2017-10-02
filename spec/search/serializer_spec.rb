# frozen_string_literal: true

require_relative '../../lib/search/serializer'

RSpec.describe Serializer do
  before(:each) do
    test_data_directory = File.expand_path('../data', File.dirname(__FILE__))
    allow(Searcher.instance).to receive(:data_directory).and_return(test_data_directory)
  end

  Searcher.instance

  let(:user) do
    {
      '_id' => 1,
      'url' => 'http://initech.zendesk.com/api/v2/users/1.json',
      'external_id' => '74341f74-9c79-49d5-9611-87ef9b6eb75f',
      'name' => 'Francisca Rasmussen',
      'alias' => 'Miss Coffey',
      'created_at' => '2016-04-15T05:19:46 -10:00',
      'active' => true,
      'verified' => true,
      'shared' => false,
      'locale' => 'en-AU',
      'timezone' => 'Sri Lanka',
      'last_login_at' => '2013-08-04T01:03:27 -10:00',
      'email' => 'coffeyrasmussen@flotonic.com',
      'phone' => '8335-422-718',
      'signature' => "Don't Worry Be Happy!",
      'organization_id' => 119,
      'tags' => [
        'Springville',
        'Sutton',
        'Hartsville/Hartley',
        'Diaperville'
      ],
      'suspended' => true,
      'role' => 'admin'
    }
  end

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
      # rubocop:disable Layout/TrailingWhitespace
      expect(subject.to_s).to eq <<~STRING
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
    end

    context 'with a related record' do
      it 'returns the result in a table with the relationships' do
        expect(Serializer.new(ticket, 'tickets').to_s).to eq <<~STRING
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

      STRING
      end
    end
  end

  # Testing the remaining data source
  context 'with a user' do
    it 'serializes the result' do
      expect(Serializer.new(user, 'users').to_s).to eq <<~STRING
        _id: 1
        url: http://initech.zendesk.com/api/v2/users/1.json
        external_id: 74341f74-9c79-49d5-9611-87ef9b6eb75f
        name: Francisca Rasmussen
        alias: Miss Coffey
        created_at: 2016-04-15T05:19:46 -10:00
        active: true
        verified: true
        shared: false
        locale: en-AU
        timezone: Sri Lanka
        last_login_at: 2013-08-04T01:03:27 -10:00
        email: coffeyrasmussen@flotonic.com
        phone: 8335-422-718
        signature: Don't Worry Be Happy!
        organization_id: 119
        tags:
        -- Springville, Sutton, Hartsville/Hartley, Diaperville
        suspended: true
        role: admin
        organization: 
        tickets:
        -- _id: fc5a8a70-3814-4b17-a6e9-583936fca909
        -- url: http://initech.zendesk.com/api/v2/tickets/fc5a8a70-3814-4b17-a6e9-583936fca909.json
        -- external_id: e8cab26b-f3b9-4016-875c-b0d9a258761b
        -- created_at: 2016-07-08T07:57:15 -10:00
        -- type: problem
        -- subject: A Nuisance in Kiribati
        -- description: Ipsum reprehenderit non ea officia labore aute. Qui sit aliquip ipsum nostrud anim qui pariatur ut anim aliqua non aliqua.
        -- priority: high
        -- status: open
        -- submitter_id: 1
        -- assignee_id: 19
        -- organization_id: 120
        -- tags:
        -- -- Minnesota, New Jersey, Texas, Nevada
        -- has_incidents: true
        -- via: voice
        -- 
        -- _id: b776f78f-e3ac-4139-9a8f-6f905472f44d
        -- url: http://initech.zendesk.com/api/v2/tickets/b776f78f-e3ac-4139-9a8f-6f905472f44d.json
        -- external_id: 32437120-7e6f-448b-b108-b659f244f1b5
        -- created_at: 2016-03-27T04:49:07 -11:00
        -- type: task
        -- subject: A Nuisance in Virgin Islands (US)
        -- description: Elit est consectetur deserunt velit magna non ea. Eiusmod minim proident ullamco est.
        -- priority: high
        -- status: pending
        -- submitter_id: 1
        -- assignee_id: 73
        -- organization_id: 111
        -- tags:
        -- -- Washington, Wyoming, Ohio, Pennsylvania
        -- has_incidents: true
        -- due_at: 2016-08-01T12:32:09 -10:00
        -- via: voice
        -- 
        -- _id: cb304286-7064-4509-813e-edc36d57623d
        -- url: http://initech.zendesk.com/api/v2/tickets/cb304286-7064-4509-813e-edc36d57623d.json
        -- external_id: df00b850-ca27-4d9a-a91a-d5b8d130a79f
        -- created_at: 2016-03-30T11:43:24 -11:00
        -- type: task
        -- subject: A Nuisance in Saint Lucia
        -- description: Nostrud veniam eiusmod reprehenderit adipisicing proident aliquip. Deserunt irure deserunt ea nulla cillum ad.
        -- priority: urgent
        -- status: pending
        -- submitter_id: 1
        -- assignee_id: 11
        -- organization_id: 106
        -- tags:
        -- -- Missouri, Alabama, Virginia, Virgin Islands
        -- has_incidents: false
        -- due_at: 2016-08-03T04:44:08 -10:00
        -- via: chat
        -- 
        -- _id: 25cb699f-a5dd-45d8-9bc1-9c4b7d096946
        -- url: http://initech.zendesk.com/api/v2/tickets/25cb699f-a5dd-45d8-9bc1-9c4b7d096946.json
        -- external_id: e85c7f58-59ed-4e05-9734-eb2a3aa92fa8
        -- created_at: 2016-04-03T04:05:26 -10:00
        -- type: problem
        -- subject: A Problem in Syria
        -- description: Consequat Lorem esse non et labore. Eiusmod veniam amet est anim minim laborum anim qui ipsum magna velit pariatur tempor.
        -- priority: high
        -- status: solved
        -- submitter_id: 59
        -- assignee_id: 1
        -- organization_id: 102
        -- tags:
        -- -- American Samoa, Northern Mariana Islands, Puerto Rico, Idaho
        -- has_incidents: true
        -- due_at: 2016-08-10T07:23:05 -10:00
        -- via: chat
        -- 
        -- _id: 1fafaa2a-a1e9-4158-aeb4-f17e64615300
        -- url: http://initech.zendesk.com/api/v2/tickets/1fafaa2a-a1e9-4158-aeb4-f17e64615300.json
        -- external_id: f6f639a4-a8af-4910-804f-5c3a80252653
        -- created_at: 2016-01-15T11:52:49 -11:00
        -- type: problem
        -- subject: A Problem in Russian Federation
        -- description: Elit exercitation veniam commodo nulla laboris. Dolore occaecat cillum nisi amet in.
        -- priority: low
        -- status: solved
        -- submitter_id: 44
        -- assignee_id: 1
        -- organization_id: 115
        -- tags:
        -- -- Georgia, Tennessee, Mississippi, Marshall Islands
        -- has_incidents: true
        -- due_at: 2016-08-07T04:10:34 -10:00
        -- via: voice
        -- 
        -- _id: 13aafde0-81db-47fd-b1a2-94b0015803df
        -- url: http://initech.zendesk.com/api/v2/tickets/13aafde0-81db-47fd-b1a2-94b0015803df.json
        -- external_id: 6161e938-50cc-4545-acff-a4f23649b7c3
        -- created_at: 2016-03-30T08:35:27 -11:00
        -- type: task
        -- subject: A Problem in Malawi
        -- description: Lorem ipsum eiusmod pariatur enim. Qui aliquip voluptate cupidatat eiusmod aute velit non aute ullamco.
        -- priority: urgent
        -- status: solved
        -- submitter_id: 42
        -- assignee_id: 1
        -- organization_id: 122
        -- tags:
        -- -- New Mexico, Nebraska, Connecticut, Arkansas
        -- has_incidents: false
        -- due_at: 2016-08-08T03:25:53 -10:00
        -- via: voice

      STRING
    end
  end
end
