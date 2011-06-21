require 'spec_helper'

describe Hashblue::Message do
  let :client do
    Hashblue::Client.new('hashblue-access-token')
  end

  subject do
    Hashblue::Message.new(client, {
      'sent' => true,
      'favourite' => false,
      'contact' => {
        'messages' => 'https://api.example.com/contacts/2/messages'
      }
    })
  end

  describe '#contact' do
    it "returns Contact built with contact attributes" do
      subject.contact.should eql(Hashblue::Contact.new(client, {
        'messages' => 'https://api.example.com/contacts/2/messages'
      }))
    end
  end
end