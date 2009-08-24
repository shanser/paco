require 'test_helper'

class TagTest < ActiveSupport::TestCase
  should_validate_presence_of :description
end
