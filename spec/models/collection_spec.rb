require 'spec_helper'

describe Hashblue::Collection do
  let :client do
    Hashblue::Client.new('hashblue-access-token')
  end

  describe "in general" do
    subject do
      Hashblue::Collection.new(client, Hashblue::Contact, {"contacts" => [
        {'msisdn' => 1}, {'msisdn' => 2}, {'msisdn' => 3}
      ]}, "contacts")
    end

    it "passes array methods to an array of models built from provided data" do
      subject[0].should eql(Hashblue::Contact.new(client, {'msisdn' => 1}))
      subject.size.should eql(3)
      subject.collect {|c| c.msisdn}.should eql([1, 2, 3])
    end
  end

  describe "a collection without a next_page_uri" do
    subject do
      Hashblue::Collection.new(client, Hashblue::Contact, {"contacts" => []}, "contacts")
    end

    describe '#next_page?' do
      it "returns false" do
        subject.next_page?.should be_false
      end
    end

    describe '#next_page' do
      it "returns nil" do
        subject.next_page.should be_false
      end
    end

    describe '#each_page(&block)' do
      it 'yields itself' do
        pages = []
        subject.each_page do |page|
          pages << page
        end
        pages.should eql([subject])
      end
    end
  end

  describe "a collection with a next_page_uri" do
    subject do
      Hashblue::Collection.new(client, Hashblue::Contact, {"contacts" => [], "next_page_uri" => "https://api.example.com/contacts/more"}, "contacts")
    end

    describe '#next_page?' do
      it "returns true" do
        subject.next_page?.should be_true
      end
    end

    describe '#next_page' do
      it "returns a new collection built from the response from the next_page_uri" do
        subject
        response = {"contacts" => []}
        client.stubs(:get).with("https://api.example.com/contacts/more").returns(response)
        collection = mock()
        Hashblue::Collection.expects(:new).with(client, Hashblue::Contact, response, "contacts").returns(collection)
        subject.next_page.should eql(collection)
      end
    end

    describe '#each_page(&block)' do
      it 'yields each page in turn' do
        subject
        response = {"contacts" => []}
        client.stubs(:get).with("https://api.example.com/contacts/more").returns(response)
        collection = Hashblue::Collection.new(client, Hashblue::Contact, {"contacts" => []}, "contacts")
        Hashblue::Collection.expects(:new).with(client, Hashblue::Contact, response, "contacts").returns(collection)

        pages = []
        subject.each_page do |page|
          pages << page
        end
        pages.should eql([subject, collection])
      end
    end
  end

  describe "a collection without a previous_page_uri" do
    subject do
      Hashblue::Collection.new(client, Hashblue::Contact, {"contacts" => []}, "contacts")
    end

    describe '#previous_page?' do
      it "returns false" do
        subject.next_page?.should be_false
      end
    end

    describe '#previous_page' do
      it "returns nil" do
        subject.next_page.should be_false
      end
    end
  end

  describe "a collection with a previous_page_uri" do
    subject do
      Hashblue::Collection.new(client, Hashblue::Contact, {"contacts" => [], "previous_page_uri" => "https://api.example.com/contacts/less"}, "contacts")
    end

    describe '#previous_page?' do
      it "returns true" do
        subject.previous_page?.should be_true
      end
    end

    describe '#previous_page' do
      it "returns a new collection built from the response from the next_page_uri" do
        subject
        response = {"contacts" => []}
        client.stubs(:get).with("https://api.example.com/contacts/less").returns(response)
        collection = mock()
        Hashblue::Collection.expects(:new).with(client, Hashblue::Contact, response, "contacts").returns(collection)
        subject.previous_page.should eql(collection)
      end
    end
  end
end