require 'json'
require 'active_model'

class TestFile
  attr_accessor :name
  attr_accessor :test_file_text
  # The tests which will be run. May differ from test_file_text if the
  attr_reader :compiled_test_file_text
  # Boolean - if set to true, the tests will be run
  attr_accessor :run_tests
  # The list of domains in compiled_test_file_text
  attr_reader :domains
  # How often the test file is run, in seconds (e.g. 3600 = once every hour)
  attr_reader :frequency
  attr_reader :id
  attr_reader :tutorial_id
  attr_reader :updated_at
  attr_reader :created_at
  
  # A rails style error object (using ActiveModel::Errors) - use errors.full_messages to access an array of error messages
  attr_reader :errors
  
  protected
  
  def self.attribute_method?(attribute) #:nodoc:
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
  
  public
  
  extend ActiveModel::Naming 
  # Required dependency for ActiveModel::Errors
  
  class << self
    private
    
    # Required in order for ActiveModel::Errors to work correctly
    def self.human_attribute_name(attr, options = {})
      attr
    end

    # Required in order for ActiveModel::Errors to work correctly
    def self.lookup_ancestors
      [self]
    end
  end
  
  private

  # Required in order for ActiveModel::Errors to work correctly
  def read_attribute_for_validation(attr)
    send(attr)
  end
  
  public
  
  def initialize(args={})
    args.each do |attr, value|
      self.public_send("#{attr}=", value)
    end if args
  end
  
  
  #################
  # Class Methods #
  #################
  
  # GET "https://www.citrulu.com/api/v1/test_files?auth_token=abcdefg"
  def self.all
    response = Citrulu.connection.get "test_files" 
    attr_array = JSON.parse(response.body)
    attr_array.map{ |attrs| build(attrs)}
  end
  
  # GET "https://www.citrulu.com/api/v1/test_files/2?auth_token=abcdefg"
  def self.find(id)
    response = Citrulu.connection.get "test_files/#{id}"
    # parse_response(response.body)
    
    # TEMPORARY: there's a bug in the api which means that it returns an array instead of a single hash,
    # so we'll be hacky for now:
    attrs = JSON.parse(response.body)
    build(attrs.first)
  end
  
  # POST "https://www.citrulu.com/api/v1/test_files?name=foo&test_file_text=bar&run_tests=false&auth_token=abcdefg"
  def self.create(options={})
    response = Citrulu.connection.post "test_files", options
    body = JSON.parse(response.body)
    
    if response.status == 200
      build(body)
    else # 422 - validation errors
      test_file = build(options)
      add_all_errors(test_file, body["errors"])
      return test_file
    end
  end
    
  # PUT "https://www.citrulu.com/api/v1/test_files/2?name=foz&test_file_text=baz&run_tests=true&auth_token=abcdefg"
  def self.update(id, options={})
    response = Citrulu.connection.put "test_files/#{id}", options
    body = JSON.parse(response.body)
    
    if response.status == 200
      build(body)
    else # 422 - validation errors
      test_file = find(id)
      add_all_errors(test_file, body["errors"])
      return test_file
    end
  end
  
  # DELETE "https://www.citrulu.com/api/v1/test_files/2?auth_token=abcdefg"
  # Status 204 = successful deletion
  def self.delete(id)
    Citrulu.connection.delete "test_files/#{id}"
  end
  
  # POST "https://www.citrulu.com/api/v1/test_files/compile/?auth_token=abcdefg"
  # status: 201 = successful compilation
  def self.compile(id)
    response = Citrulu.connection.post "test_files/compile/#{id}"
    parse_response(response.body)
  end
  
  
  ####################
  # Instance Methods #
  ####################
  
  # Create or update the current test file on Citrulu
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
  
  # Deletes the current test file on Citrulu
  def destroy
    self.class.delete(id)
  end
  
  # Attempts to compile the test file. Returns any compilation errors as an errors object. Use errors.full_messages to access the array of error messages.
  def compile
    self.class.compile(id)
  end
  
  # TODO: Helper methods to write:
  # .prepend, .append - TDD THEM!!!
  
  
  ####################
  # Utility Methods #
  ####################
  
  class << self
    private
    
    def build(attrs={})
      test_file = allocate
      attrs.each do |k,v|
        raise ArgumentError.new("Unknown attribute: #{k}") unless TestFile.attribute_method?(k.to_sym)
        test_file.instance_variable_set("@#{k}", v) unless v.nil?
      end
      test_file.instance_variable_set("@errors", ActiveModel::Errors.new(test_file))
      
      return test_file
    end
    
    def add_all_errors(test_file, error_hash)
      error_hash.each do |attribute, messages|
        messages.each do |message|
          test_file.errors.add(attribute.to_sym, message)
        end
      end
    end
    
    def parse_response(json)
      attrs = JSON.parse(json)
      build(attrs)
    end    
  end
end