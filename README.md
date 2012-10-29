Citrulu
=======
A wrapper for the [Citrulu api](https://www.citrulu.com/api)

Setup
-----

You need an account on Citrulu to use the gem: Sign up at <http://www.citrulu.com>, and once you're signed in you can create an API key on the '[Account Settings](https://www.citrulu.com/settings)' page.
 
Configure your API key by adding it to an initializer: 

    #config/initializers/citrulu_auth.rb
    CITRULU_API_KEY = "abcdefgh"

Usage
-----

You can interact with TestFile instances in the same way that you'd interact with a model:

List test files

    TestFile.all
    
Create a new test file
    
    test_file = TestFile.new( name:           "My first test file",
                              test_file_text: "On http://www.google.com",
                              run_tests:      "true" )
    test_file.save
    
    # test files must have be successfully compiled before they will be run:
    test_file.compile 
    
Find a specific test file by and update it:
    
    test_file = TestFile.find(23)
    test_file.update(run_tests: false)
    test_file.save
    
Delete a test file:
    
    test_file = TestFile.find(23)
    test_file.destroy


Contributing to the Citrulu gem 
-------------------------------
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Authors
-------
Duncan Stuart (duncan@dxw.com)

contact@dxw.com

Copyright
---------
Copyright (c) 2012 The Dextrous Web Ltd. See LICENSE.txt for further details.
