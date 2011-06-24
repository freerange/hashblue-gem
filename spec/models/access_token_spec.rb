require 'spec_helper'

describe Hashblue::AccessToken do
  subject do
    Hashblue::AccessToken.new('access-token')
  end

  describe '#to_s' do
    it 'returns the access token' do
      subject.to_s.should eql('access-token')
    end
  end

  describe 'valid?' do
    it 'is true if a request to /account succeeds' do
      subject.client.stubs(:head).returns
      subject.valid?.should be_true
    end

    it 'is false if a request to /account raises a RequestError' do
      subject.client.stubs(:head).raises(Hashblue::Client::RequestError)
      subject.valid?.should be_false
    end
  end

  describe 'refresh_with' do
    before :each do
      @response = {
        "expires_in" => 2592000,
        "refresh_token" => "new-refresh-token",
        "access_token"=>"new-access-token"
      }

      subject.client.expects(:post).with('/oauth/access_token', {
        'grant_type' => 'refresh_token',
        'refresh_token' => 'provided-refresh-token',
        'client_id' => 'client-identifier',
        'client_secret' => 'client-secret'
      }, nil).returns(@response)
    end

    it 'returns response' do
      response = subject.refresh_with('client-identifier', 'client-secret', 'provided-refresh-token')
      response.should eql(@response)
    end

    it 'updates its own access token' do
      subject.refresh_with('client-identifier', 'client-secret', 'provided-refresh-token')
      subject.to_s.should == @response["access_token"]
    end
  end
end