FactoryGirl.define do
  factory :test_file do
    sequence(:name) { |n| "my first test file#{n}" }
    test_file_text  "On http://example.com\n  I should see foo"
    run_tests       true
    
    factory :full_test_file do
      domains     ["example.com"] 
      frequency   3600
      updated_at  "2012-06-06T13:33:20Z"
      created_at  "2012-09-24T12:43:15Z"
      
      factory :compiled_test_file do
        compiled_test_file_text "On http://example.com\n  I should see foo"
      end
      
      factory :tutorial_test_file do
        tutorial_id 1
      end
    end
  end
end