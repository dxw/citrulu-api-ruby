require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "TestFile" do
  before(:each) do
    @connection = double("Connection")
    # @connection.stub(:get)
    # @connection.stub(:put)
    # @connection.stub(:post)
    # @connection.stub(:delete)
    
    # Faraday.stub(:new).and_return(@connection)
    
    API.stub(:connection).and_return(@connection)    
    stub_const("API_KEY", "Foo")
    
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
      TestFile.find(1).should be_a(TestFile)
    end
  end
  
  describe ".create" do
    before(:each) do
      stub_file_response(:post)
    end
    it "should return a test_file" do
      TestFile.create.should be_a(TestFile)
    end
  end
  
  describe ".update" do
    before(:each) do
      stub_file_response(:put)
    end
    it "should return a test_file" do
      TestFile.update(1).should be_a(TestFile)
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
    it "should create the file if it doesn't exist"
    it "should update the file if it already exists"
  end
  
  describe "destroy" do
    it "should delete the file"
  end
  
  describe "compile" do
    it "should compile the file"
  end
  
end
