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
end