require 'spec_helper'

describe Hashblue::Contact do
  let :client do
    Hashblue::Client.new('hashblue-access-token')
  end

  subject do
    Hashblue::Contact.new(client, {
      'uri' => 'https://api.example.com/contacts/abcdef123456',
      'messages' => 'https://api.example.com/contact/1/messages',
    })
  end

  describe '#messages' do
    it "loads messages from its messages uri" do
      client.expects(:load_messages).with('https://api.example.com/contact/1/messages', {}).returns([:some_messages])
      subject.messages.should eql([:some_messages])
    end
  end

  describe '#delete!' do
    it "sends a delete request to the contact uri" do
      client.expects(:delete).with('https://api.example.com/contacts/abcdef123456')
      subject.delete!
    end
  end
end