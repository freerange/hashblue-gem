require 'spec_helper'

describe Hashblue::Account do
  let :client do
    Hashblue::Client.new('hashblue-access-token')
  end

  subject do
    Hashblue::Account.new(
      'messages' => 'https://api.example.com/messages',
      'contacts' => 'https://api.example.com/contacts',
      'favourite_messages' => 'https://api.example.com/messages/favourites'
    ).tap {|a| a.client = client}
  end

  describe '.authenticate' do
    it "returns Account model built with response from GET /account" do
      client.class.stubs(:new).with('access-token').returns(client)
      attributes = {
        "msisdn" => "4479001234567"
      }
      client.stubs(:get).with('/account').returns("account" => attributes)
      Hashblue::Account.authenticate('access-token').should eql(Hashblue::Account.new(attributes))
    end
  end

  describe '#messages' do
    it "loads messages from its messages uri" do
      client.expects(:load_messages).with('https://api.example.com/messages', {}).returns([:some_messages])
      subject.messages.should eql([:some_messages])
    end
  end

  describe '#contacts' do
    it "loads contacts from its contacts uri" do
      client.expects(:load_contacts).with('https://api.example.com/contacts', {}).returns([:some_contacts])
      subject.contacts.should eql([:some_contacts])
    end
  end

  describe '#favourite_messages' do
    it "loads messages from its favourite messages uri" do
      client.expects(:load_messages).with('https://api.example.com/messages/favourites', {}).returns([:some_messages])
      subject.favourite_messages.should eql([:some_messages])
    end
  end
end