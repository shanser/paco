require 'test_helper'

class EtiquetageTest < ActiveSupport::TestCase
  should_validate_presence_of :tache, :tag
end
