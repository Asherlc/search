require_relative '../lib/searcher'

RSpec.describe Searcher do
  subject do
    test_data_directory = File.expand_path('./data',  File.dirname(__FILE__))
    allow(Searcher.instance).to receive(:data_directory).and_return(test_data_directory)

    Searcher.instance
  end

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

  let(:organization_102) {
    {
      "_id" => 102,
      "url" => "http://initech.zendesk.com/api/v2/organizations/102.json",
      "external_id" => "7cd6b8d4-2999-4ff2-8cfd-44d05b449226",
      "name" => "Nutralab",
      "domain_names" => [
        "trollery.com",
        "datagen.com",
        "bluegrain.com",
        "dadabase.com"
      ],
      "created_at" => "2016-04-07T08:21:44 -10:00",
      "details" => "Non profit",
      "shared_tickets" => true,
      "tags" => [
        "Cherry",
        "Collier",
        "Fuentes",
        "Trevino"
      ]
    }
  }

  describe "#perform" do
    context "with a match" do
      it "returns the result in an array" do
        expect(subject.perform('organizations', '_id', 101)).to eq([organization_101])
      end

      context 'with an array attribute' do
        it 'returns the matching result' do
          expect(subject.perform('organizations', 'tags', 'Fulton')).to eq([organization_101])
        end
      end
    end

    context 'with a boolean value' do
      it 'returns the matching result' do
        expect(subject.perform('organizations', 'shared_tickets', true)).to eq([organization_102])
      end

      context 'but the boolean value is in string form' do
        it 'returns the matching result' do
          expect(subject.perform('organizations', 'shared_tickets', 'true')).to eq([organization_102])
        end
      end
    end

    context 'with multiple matches' do
      it 'returns the matching results' do
         expect(subject.perform('organizations', 'tags', 'Trevino')).to eq([organization_101, organization_102])
      end
    end

    context 'with an empty value' do
      it 'returns the matching results' do
         expect(subject.perform('organizations', 'details', nil)).to eq([organization_101])
      end
    end
  end

  context 'without a match' do
    it 'returns an empty array' do
      expect(subject.perform('organizations', 'tags', 'Joe Divola')).to eq([])
    end
  end

  context 'with an invalid search key' do
    it 'raises an error' do
      expect { subject.perform('organizations', 'seinfeld characters', 'Joe Divola') }.to raise_error(AttributeError)
    end
  end
end