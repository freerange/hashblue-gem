require 'spec_helper'

describe Hashblue::Client do
  subject do
    Hashblue::Client.new('hashblue-access-token')
  end

  describe 'all requests' do
    it 'point to api.hashblue.com' do
      Hashblue::Client.base_uri.should == 'https://api.hashblue.com'
    end

    it 'request json responses' do
      Hashblue::Client.headers['Accept'].should == 'application/json'
    end

    it 'include a user-agent' do
      Hashblue::Client.headers['User-Agent'].should_not be_nil
    end
  end

  describe '#get' do
    it "makes requests with Authorization and Accept headers and passed query" do
      Hashblue::Client.expects(:get).with("/messages",
        :headers => Hashblue::Client.headers.merge({
          "Authorization" => "OAuth hashblue-access-token"
        }),
        :query => {
          :since => '2011-01-14T14:30Z'
        }
      ).returns(mock(:code => 200, :to_hash => {}))
      subject.get "/messages", :since => '2011-01-14T14:30Z'
    end

    it "raises RequestError if response code isn't 200" do
      Hashblue::Client.expects(:get).with("/messages",
        :headers => Hashblue::Client.headers.merge({
          "Authorization" => "OAuth hashblue-access-token"
        }),
        :query => {}
      ).returns(mock(:code => 500, :inspect => ""))
      lambda {subject.get "/messages"}.should raise_error(Hashblue::Client::RequestError)
    end
  end

  describe '#load_messages(uri, query)' do
    it "builds a Collection of messages with the response from the uri" do
      response = {"messages" => [{"content" => "hello"}]}
      subject.stubs(:get).returns(response)
      collection = mock()
      Hashblue::Collection.expects(:new).with(subject, Hashblue::Message, response, "messages").returns(collection)
      subject.load_messages("/messages")
    end
  end

  describe '#load_contacts(uri, query)' do
    it "builds a Collection of contacts with the response from the uri" do
      response = {"contacts" => [{"msisdn" => "1234"}]}
      subject.stubs(:get).returns(response)
      collection = mock()
      Hashblue::Collection.expects(:new).with(subject, Hashblue::Contact, response, "contacts").returns(collection)
      subject.load_contacts("/contacts")
    end
  end
end