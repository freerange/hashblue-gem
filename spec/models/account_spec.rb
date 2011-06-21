require 'spec_helper'

describe Hashblue::Account do
  let :client do
    Hashblue::Client.new('hashblue-access-token')
  end

  subject do
    Hashblue::Account.new(client, {
      'messages' => 'https://api.example.com/messages',
      'contacts' => 'https://api.example.com/contacts'
    })
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
end