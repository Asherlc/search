require_relative '../app/lib/serializer'

RSpec.describe Serializer do
  before(:each) do
    test_data_directory = File.expand_path('./data',  File.dirname(__FILE__))
    allow(Searcher.instance).to receive(:data_directory).and_return(test_data_directory)
  end

  Searcher.instance
  
  let(:organization_101) {
    {
      "_id" => 101,
      "url" => "http://initech.zendesk.com/api/v2/organizations/101.json",
      "external_id" => "9270ed79-35eb-4a38-a46f-35725197ea8d",
      "name" => "Enthaze",
      "domain_names" => [
        "kage.com",
        "ecratic.com",
        "endipin.com",
        "zentix.com"
      ],
      "created_at" => "2016-05-21T11:10:28 -10:00",
      "details" => "",
      "shared_tickets" => false,
      "tags" => [
        "Fulton",
        "West",
        "Rodriguez",
        "Farley",
        "Trevino"
      ]
    }
  }

  let(:ticket) {
    {
      "_id" => "436bf9b0-1147-4c0a-8439-6f79833bff5b",
      "url" => "http://initech.zendesk.com/api/v2/tickets/436bf9b0-1147-4c0a-8439-6f79833bff5b.json",
      "external_id" => "9210cdc9-4bee-485f-a078-35396cd74063",
      "created_at" => "2016-04-28T11:19:34 -10:00",
      "type" => "incident",
      "subject" => "A Catastrophe in Korea (North)",
      "description" => "Nostrud ad sit velit cupidatat laboris ipsum nisi amet laboris ex exercitation amet et proident. Ipsum fugiat aute dolore tempor nostrud velit ipsum.",
      "priority" => "high",
      "status" => "pending",
      "submitter_id" => 38,
      "assignee_id" => 24,
      "organization_id" => 116,
      "tags" => [
        "Ohio",
        "Pennsylvania",
        "American Samoa",
        "Northern Mariana Islands"
      ],
      "has_incidents" => false,
      "due_at" => "2016-07-31T02:37:50 -10:00",
      "via" => "web"
    }
  }

  subject {
    Serializer.new(organization_101, 'organizations')
  }

  describe "#to_s" do
    it "returns the result in a table" do
      puts subject.to_s
    end

    context 'with a related record' do
      it "returns the result in a table" do
        puts Serializer.new(ticket, 'tickets').to_s
      end
    end
  end
end