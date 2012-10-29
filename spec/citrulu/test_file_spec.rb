require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require 'json'

describe "TestFile" do
  before(:each) do
    @connection = double("Connection")
    Citrulu.stub(:connection).and_return(@connection)    
    stub_const("CITRULU_API_KEY", "Foo")
    @response = double("Response")
  end
  
  FILE_JSON = { "compiled_test_file_text"=>"On http://swingoutlondon.co.uk", 
                "created_at"=>"2012-03-15T17:57:14Z", 
                "domains"=>["swingoutlondon.co.uk"], 
                "frequency"=>3600, 
                "id"=>2, 
                "name"=>"Swing Out London", 
                "run_tests"=>true, 
                "test_file_text"=>"On http://swingoutlondon.co.uk", 
                "tutorial_id"=>nil, "updated_at"=>"2012-10-16T12:58:27Z"}.to_json
  
  def stub_file_response(method)
    @response.stub(:body).and_return(FILE_JSON)
    @connection.stub(method).and_return(@response)
  end
  
  # TODO: this feels like a big dirty hack...
  def make_test_file(name, options={})
    attrs = FactoryGirl.attributes_for(name, options)
    TestFile.send(:build, attrs)
  end
  
  ################
  # Constructors #
  ################
  
  describe "initialize" do
    it "should fail if a supplied attribute is invalid" do
      expect{ TestFile.new(:foo => "bar") }.to raise_error(NoMethodError)
    end
  end
  
  describe "build" do
    it "should be private" do
      expect{ TestFile.build(:frequency => "1000") }.to raise_error(NoMethodError)
    end
  end
  
  #################
  # Class Methods #
  #################
  
  describe ".all" do
    before(:each) do
      response_body = [ { id: 2,  name: "Swing Out London" },
                        { id: 29, name: "Tutorial 6: I'm broken - fix me" }
                      ].to_json
      @response.stub(:body).and_return(response_body)
      @connection.stub(:get).and_return(@response)
    end
    it "should return an array" do
      Faraday.stub(:new).and_return @connection
      TestFile.all.should be_an(Array)
    end
    it "should return an array of test_files" do
      TestFile.all.first.should be_a(TestFile)
    end
  end
  
  describe ".find" do
    before(:each) do
      stub_file_response(:get)
    end
    it "should return a test_file" do
      pending "The API needs fixing - currently it's returning an array instead of a single JSON hash"
      TestFile.find(1).should be_a(TestFile)
    end
  end
  
  describe ".create" do
    before(:each) do
      stub_file_response(:post)
    end
    context "when the file was successfully created" do
      before(:each) do
        @response.stub(:status).and_return(200)
      end
      it "should return a test_file" do
        TestFile.create.should be_a(TestFile)
      end
    end
    context "when the file was not successfully created" do
      before(:each) do
        @response.stub(:status).and_return(422)
        @response.stub(:body).and_return(%({"errors":{"name":["can't be blank"]}}))
      end
      it "should return a test_file" do
        TestFile.create.should be_a(TestFile)
      end
      it "should add the errors onto the test file object" do
        TestFile.create.errors.messages.should == { :name => ["can't be blank"] }
      end
    end
  end
  
  describe ".update" do
    before(:each) do
      stub_file_response(:put)
    end
    context "when the file was successfully created" do
      before(:each) do
        @response.stub(:status).and_return(200)
      end
      it "should return a test_file" do
        TestFile.update(1).should be_a(TestFile)
      end
    end
    context "when the file was not successfully created" do
      before(:each) do
        @response.stub(:status).and_return(422)
        @response.stub(:body).and_return(%({"errors":{"name":["can't be blank"]}}))
        stub_file_response(:get)
      end
      it "should return a test_file" do
        pending "Need the API Find to be fixed before this will pass"
        TestFile.update(1).should be_a(TestFile)
      end
      it "should add the errors onto the test file object" do
        pending "Need the API Find to be fixed before this will pass"
        TestFile.update(1).errors.messages.should == { :name => ["can't be blank"] }
      end
    end
  end
  
  describe ".delete" do
    before(:each) do
      @connection.stub(:delete)
    end
    it "should return nothing" do
      TestFile.delete(1).should be_nil
    end
  end
  
  describe ".compile" do
    before(:each) do
      stub_file_response(:post)
    end
    it "should return a test_file" do
      TestFile.compile(1).should be_a(TestFile)
    end
  end
  
  ####################
  # Instance Methods #
  ####################  
  
  describe "save" do
    it "should create the file if it doesn't exist" do
      TestFile.stub(:create)
      TestFile.should_receive(:create)
      
      TestFile.new(name: "foo", test_file_text: "bar", run_tests: true).save
    end
    it "should update the file if it already exists" do
      TestFile.stub(:update)
      TestFile.should_receive(:update)
      
      make_test_file(:full_test_file, id: 1).save
    end
  end
  
  describe "destroy" do
    it "should delete the file" do
      TestFile.stub(:delete)
      TestFile.should_receive(:delete)
      
      make_test_file(:full_test_file, id: 1).destroy
    end
  end
  
  describe "compile" do
    it "should compile the file" do
      TestFile.stub(:compile)
      TestFile.should_receive(:compile)
      
      make_test_file(:full_test_file, id: 1).compile
    end
  end  
end