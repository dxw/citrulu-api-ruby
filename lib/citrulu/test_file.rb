require 'json'

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
  
  def self.attribute_method?(attribute)
    [ :name,
      :test_file_text,
      :compiled_test_file_text,
      :run_tests,
      :domains,
      :frequency,
      :id,
      :tutorial_id,
      :updated_at,
      :created_at,
    ].include?(attribute)
  end 
  
  def initialize(args={})
    args.each do |k,v|
      raise ArgumentError.new("Unknown attribute: #{k}") unless TestFile.attribute_method?(k.to_sym)
      instance_variable_set("@#{k}", v) unless v.nil?
    end
  end
  
  #################
  # Class Methods #
  #################
  
  # GET "https://www.citrulu.com/api/v1/test_files?auth_token=abcdefg"
  def self.all
    response = Citrulu.connection.get "test_files"
    attr_array = JSON.parse(response.body)
    attr_array.map{ |attrs| TestFile.new(attrs)}
  end
  
  # GET "https://www.citrulu.com/api/v1/test_files/2?auth_token=abcdefg"
  def self.find(id)
    response = Citrulu.connection.get "test_files/#{id}"
    # parse_response(response.body)
    
    # TEMPORARY: there's a bug in the api which means that it returns an array instead of a single hash,
    # so we'll be hacky for now:
    attrs = JSON.parse(response.body)
    TestFile.new(attrs.first)
  end
  
  
  # TODO: create, update, delete and compile should be private (???)
  # instead these actions should be achieved through new, save, destroy and compile (???)
  
  # POST "https://www.citrulu.com/api/v1/test_files?name=foo&test_file_text=bar&run_tests=false&auth_token=abcdefg"
  def self.create(options={})
    response = Citrulu.connection.post "test_files", options
    parse_response(response.body)
  end
    
  # PUT "https://www.citrulu.com/api/v1/test_files/2?name=foz&test_file_text=baz&run_tests=true&auth_token=abcdefg"
  def self.update(id, options={})
    response = Citrulu.connection.put "test_files/#{id}", options
    parse_response(response.body)
  end
  
  # DELETE "https://www.citrulu.com/api/v1/test_files/2?auth_token=abcdefg"
  def self.delete(id)
    Citrulu.connection.delete "test_files/#{id}"
    # Possible results:
    # 204 - successful deletion
    # ??? - failed deletion
  end
  
  # POST "https://www.citrulu.com/api/v1/test_files/compile/?auth_token=abcdefg"
  def self.compile(id)
    response = Citrulu.connection.post "test_files/compile/#{id}"
    parse_response(response.body)
    # Possible results:
    # 201 - successful compilation
    # 422 - unprocessable entity = failed compilation
  end
  
  
  ####################
  # Instance Methods #
  ####################
  
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
  
  # TODO: Helper methods to write:
  # .prepend, .append - TDD THEM!!!
  
  
  private 
  
  def self.parse_response(json)
    attrs = JSON.parse(json)
    TestFile.new(attrs)
  end  
end