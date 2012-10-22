BASE_URL = "https://www.citrulu.com/api"
API_VERSION = "v1"
API_KEY = "jwhsfQdkx3MrKGUnssbH" # TODO!!!- this is DUNCAN's api key!!! make configurable


require 'faraday'
require 'json'

# Helper methods to write:
# .prepend, .append - TDD THEM!!!

class API
  def self.connection
    Faraday.new(:url => "#{BASE_URL}/#{API_VERSION}") do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end
end

class TestFile
  attr_accessor :name
  attr_accessor :test_file_text
  attr_reader :compiled_test_file_text
  attr_accessor :run_tests
  attr_reader :domains
  attr_reader :frequency
  attr_reader :id
  attr_reader :tutorial_id
  attr_reader :updated_at
  attr_reader :created_at
  
  def initialize(args={})
    args.each do |k,v|
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
  
  # GET "https://www.citrulu.com/api/v1/test_files?auth_token=abcdefg"
  def self.all
    response = API.connection.get "test_files", auth_token: API_KEY
    attr_array = JSON.parse(response.body)
    attr_array.map{ |attrs| TestFile.new(attrs)}
  end
  
  # GET "https://www.citrulu.com/api/v1/test_files/2?auth_token=abcdefg"
  def self.find(id)
    response = API.connection.get "test_files/#{id}", auth_token: API_KEY
    # parse_response(response.body)
    
    #TEMPORARY: there's a bug in the api which means that it returns an array instead of a single hash, so we'll be hacky for now:
    attrs = JSON.parse(response.body)
    TestFile.new(attrs.first)
  end
  
  
  # TODO: create, update, delete and compile should be private (???) and instead these actions should be achieved through new, save, destroy and compile (???)
  
  # POST "https://www.citrulu.com/api/v1/test_files?name=foo&test_file_text=bar&run_tests=false&auth_token=abcdefg"
  def self.create(options={})
    response = API.connection.post "test_files", options.merge(auth_token: API_KEY)
    parse_response(response.body)
  end
    
  # PUT "https://www.citrulu.com/api/v1/test_files/2?name=foz&test_file_text=baz&run_tests=true&auth_token=abcdefg"
  def self.update(id, options={})
    response = API.connection.put "test_files/#{id}", options.merge(auth_token: API_KEY)
    parse_response(response.body)
  end
  
  # DELETE "https://www.citrulu.com/api/v1/test_files/2?auth_token=abcdefg"
  def self.delete(id)
    API.connection.delete "test_files/#{id}", auth_token: API_KEY
  end
  
  # POST "https://www.citrulu.com/api/v1/test_files/compile/?auth_token=abcdefg"
  def self.compile(id)
    response = API.connection.post "test_files/compile/#{id}", auth_token: API_KEY
    parse_response(response.body)
    # Possible results: 
    # 422 - unprocessable entity = failed compilation
  end
  
  
  # Create or update the current object
  def save
    options = { name:           name,
                test_file_text: test_file_text,
                run_tests:      run_tests,     
              }
    if id
      self.class.update(id, options)
    else 
      self.class.create(options)
    end
  end
  
  def destroy
    self.class.delete(id)
  end
  
  def compile
    self.class.compile(id)
  end
  
  private 
  
  def self.parse_response(json)
    attrs = JSON.parse(json)
    TestFile.new(attrs)
  end  
end

# puts "##################"
# puts TestFile.new(name: "foo").inspect
# puts TestFile.all.inspect
# puts TestFile.find(2).inspect
# puts TestFile.create({name: "foo1", test_file_text: "On http://www.google.com", run_tests: "true"}).inspect
# puts TestFile.update(997,{name: "faz", test_file_text: "baz", run_tests: "false"})

# file = TestFile.find(998)
# file.name = "fazz"
# puts file.save.inspect

# file.destroy
# file.compile


# TestFile.update(998, test_file_text: "On http://www.google.com")
# puts TestFile.compile(1000)
# puts TestFile.find(1000).to_yaml

# puts "##################"

 