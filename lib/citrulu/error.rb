module Citrulu
  # Custom error class for rescuing from all Citrulu errors
  class Error < StandardError; end

  # Raised when Citrulu returns the HTTP status code 404
  class NotFound < Error; end
  
  # Raised when authentication failed (401)
  class AccessDenied < Error; end

  # Raised when Citrulu returns the HTTP status code 500
  class InternalServerError < Error; end
end