require "test_helper"

class DogWalkerConducerTest < ActiveSupport::TestCase
  test "there is a whitelist for dog walkers"
  test "there is a whitelist for dogs"
  test "initializes with a dog walker and optionally params"
  test "dog walker's attributes copied to conducer"
  test "params overwrite dog walker's attributes"
  test "whitelisted fields are updated on the dog walker on save"
  test "a dog walkers dogs aren't rebuilt if the id is present"
  test "whitelisted fields are updated on a dog on save"
end
