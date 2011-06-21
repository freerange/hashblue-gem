require 'spec_helper'

describe Hashblue::Client do
  subject do
    Hashblue::Client.new('hashblue-access-token')
  end

  describe '#get' do
    it "makes requests with Authorization and Accept headers and passed query" do
      Hashblue::Client.expects(:get).with("/messages",
        :headers => {
          "Authorization" => "OAuth hashblue-access-token",
          "Accept" => "application/json"
        },
        :query => {
          :since => '2011-01-14T14:30Z'
        }
      ).returns(mock(:headers => {"status" => "200"}, :to_hash => {}))
      subject.get "/messages", :since => '2011-01-14T14:30Z'
    end

    it "raises RequestError if response status isn't 200" do
      Hashblue::Client.expects(:get).with("/messages",
        :headers => {
          "Authorization" => "OAuth hashblue-access-token",
          "Accept" => "application/json"
        },
        :query => {}
      ).returns(mock(:headers => {"status" => "401"}, :to_hash => {}))
      lambda {subject.get "/messages"}.should raise_error(Hashblue::Client::RequestError)
    end
  end

  describe '#account' do
    it "returns Account model built with response from GET /account" do
      attributes = {
        "msisdn" => "4479001234567"
      }
      subject.stubs(:get).returns("account" => attributes)
      subject.account.should eql(Hashblue::Account.new(subject, attributes))
    end
  end

  describe '#messages(query = {})' do
    it "loads messages from '/messages'" do
      subject.expects(:load_messages).with('/messages', {}).returns([:some_messages])
      subject.messages.should eql([:some_messages])
    end

    it "passes query through to load_messages" do
      subject.expects(:load_messages).with('/messages', {:anything => :here})
      subject.messages(:anything => :here)
    end
  end

  describe '#contacts(query = {})' do
    it "loads contacts from '/contacts'" do
      subject.expects(:load_contacts).with('/contacts', {}).returns([:some_contacts])
      subject.contacts.should eql([:some_contacts])
    end

    it "passes query through to load_contacts" do
      subject.expects(:load_contacts).with('/contacts', {:anything => :here})
      subject.contacts(:anything => :here)
    end
  end
end