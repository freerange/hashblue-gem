require 'spec_helper'

describe Hashblue::Contact do
  let :client do
    Hashblue::Client.new('hashblue-access-token')
  end

  subject do
    Hashblue::Contact.new(
      'uri' => 'https://api.example.com/contacts/abcdef123456',
      'messages' => 'https://api.example.com/contact/1/messages'
    ).tap {|c| c.client = client }
  end

  describe '#messages' do
    it "loads messages from its messages uri" do
      client.expects(:load_messages).with(subject.messages_uri, {}).returns([:some_messages])
      subject.messages.should eql([:some_messages])
    end
  end

  describe '#send_message(content)' do
    it "posts message to messages_uri" do
      client.expects(:post).with(subject.messages_uri, {}, {"message" => {"content" => "Hello!"}})
      subject.send_message "Hello!"
    end
  end
end