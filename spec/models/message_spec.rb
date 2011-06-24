require 'spec_helper'

describe Hashblue::Message do
  let :client do
    Hashblue::Client.new('hashblue-access-token')
  end

  subject do
    Hashblue::Message.new(
      'uri' => 'https://api.example.com/messages/abcdef123456',
      'sent' => true,
      'favourite' => false,
      'contact' => {
        'messages' => 'https://api.example.com/contacts/2/messages'
      }
    ).tap {|m| m.client = client }
  end

  describe 'favourite?' do
    it "returns the 'favourite' attribute" do
      subject.favourite?.should be_false
    end
  end

  describe 'sent?' do
    it "returns the 'sent' attribute" do
      subject.sent?.should be_true
    end
  end

  describe '#contact' do
    it "returns Contact built with contact attributes" do
      subject.contact.should eql(Hashblue::Contact.new(
        'messages' => 'https://api.example.com/contacts/2/messages'
      ))
    end
  end

  describe '#delete!' do
    it "sends a delete request to the message uri" do
      client.expects(:delete).with('https://api.example.com/messages/abcdef123456')
      subject.delete!
    end
  end

  describe '#favourite!' do
    it "sends a put request to the message favourite uri" do
      client.expects(:put).with('https://api.example.com/messages/abcdef123456/favourite', {}, {})
      subject.favourite!
    end

    it "returns true when request doesn't raise an error" do
      client.stubs(:put)
      subject.favourite!.should be_true
    end

    it "sets favourite attribute to true in local model" do
      client.stubs(:put)
      subject.favourite!
      subject.favourite?.should be_true
    end
  end

  describe '#unfavourite!' do
    it "sends a delete request to the message favourite uri" do
      client.expects(:delete).with('https://api.example.com/messages/abcdef123456/favourite')
      subject.unfavourite!
    end

    it "returns true when request doesn't raise an error" do
      client.stubs(:delete)
      subject.unfavourite!.should be_true
    end

    it "sets favourite attribute to true in local model" do
      client.stubs(:delete)
      subject.unfavourite!
      subject.favourite?.should be_false
    end
  end
end