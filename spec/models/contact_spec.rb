require 'spec_helper'

describe Hashblue::Contact do
  let :client do
    Hashblue::Client.new('hashblue-access-token')
  end

  subject do
    Hashblue::Contact.new(client, {
      'messages' => 'https://api.example.com/contact/1/messages',
    })
  end

  describe '#messages' do
    it "loads messages from its messages uri" do
      client.expects(:load_messages).with('https://api.example.com/contact/1/messages', {}).returns([:some_messages])
      subject.messages.should eql([:some_messages])
    end
  end
end