require "test_helper"

class DogWalkerConducerTest < ActiveSupport::TestCase
  test "there is a whitelist for dog walkers" do
    assert(
      DogWalkerConducer.const_defined?( :DOG_WALKER_FIELDS_WHITELIST ),
      "The dog walker field whitelist isn't defined"
    )
  end

  test "there is a whitelist for dogs" do
    assert(
      DogWalkerConducer.const_defined?( :DOG_FIELDS_WHITELIST ),
      "The dog field whitelist isn't defined"
    )
  end

  test "initializes with a dog walker and optionally params" do
    raised = false
    begin
      DogWalkerConducer.new
    rescue Object => e
      raised = true
    end

    assert(
      raised,
      "The constructor isn't expecting a dog walker"
    )

    assert(
      DogWalkerConducer.new( DogWalker.new , {} ),
      "The constructor doesn't accept params"
    )
  end

  test "dog walker's attributes copied to conducer" do
    dog_walker_name = "Johnny Cash"
    dog_walker      = DogWalker.new :name => dog_walker_name
    conducer        = DogWalkerConducer.new dog_walker

    assert(
      conducer.attributes.name == dog_walker_name,
      "The dog walkers name wasn't copied to the conducer attributes"
    )
  end

  test "params overwrite dog walker's attributes" do
    dog_walker_name = "Johnny Cash"
    dog_walker      = DogWalker.new :name => dog_walker_name
    params          = { :name => "Elvis Costello" }
    conducer        = DogWalkerConducer.new dog_walker , params

    assert(
      conducer.attributes.name == params[ :name ],
      "The params did not overwrite the dog walkers attributes in the conducer"
    )
  end

  test "whitelisted fields are updated on the dog walker" do
    dog_walker_subclass = new_dog_walker_subclass
    dog_walker_attrs    = { :name => "Johnny Cash" , :bogus => "bogus" }
    dog_walker          = dog_walker_subclass.new dog_walker_attrs
    params              = { :name => "Elvis Costello" , :bogus => "bogus2" }
    conducer            = DogWalkerConducer.new dog_walker , params

    assert(
      dog_walker.bogus == dog_walker_attrs[ :bogus ],
      "The bogus attribute was not set properly"
    )

    assert(
      conducer.update_dog_walker!( :dog_walker => dog_walker ),
      "An error occurred updating the dog walker"
    )

    assert(
      dog_walker.name == params[ :name ],
      "An error occurred updating the dog walker"
    )

    assert(
      dog_walker.bogus != params[ :bogus ],
      "An attribute that wasn't in the whitelist was updated"
    )
  end

  test "whitelisted fields are updated on a dog on save" do
    dog_walker = DogWalker.new :name => "Irrelevant"
    params     = { :dogs => [
      { :name => "Ronnie the dog" }
    ] }
    conducer   = DogWalkerConducer.new dog_walker , params

    assert(
      dog_walker.dogs.size == 0,
      "The dog walker currently has some dogs"
    )

    assert(
      conducer.update_dogs!( :dogs => dog_walker.dogs ),
      "Unable to update the dogs"
    )

    assert(
      dog_walker.dogs.size > 0,
      "After updating, we still don't have any dogs"
    )

    assert(
      dog_walker.dogs.first.name == params[ :dogs ].first[ :name ],
      "The built dog doesn't have the name specified in the params"
    )
  end

  test "a dog walkers dogs aren't rebuilt if the id is present" do
    dog_walker = saved_dog_walker_mock_with_dogs
    params     = { :dogs => [
                   { :id => "1" , :name => "Ronnie the dog" }
                 ] }
    conducer   = DogWalkerConducer.new DogWalker.new , params

    original_dogs_count = dog_walker.dogs.size

    assert(
      original_dogs_count > 0,
      "There aren't any dogs to start"
    )

    assert(
      conducer.update_dogs!( :dogs => dog_walker.dogs ),
      "Unable to update the dogs"
    )

    assert(
      dog_walker.dogs.size == original_dogs_count,
      "New dogs were built"
    )

    assert(
      dog_walker.dogs.first.name == params[ :dogs ].first[ :name ],
      "The updated dog doesn't have the name specified in the params"
    )
  end

private

  def saved_dog_walker_mock_with_dogs
    Map.new( {
      :id => 1,
      :name => "Johnny Cash",
      :dogs => [
        { :id => 1 , :name => "Sadie" }
      ]
    } )
  end

  def new_dog_walker_subclass
    klass_name = "DogWalkerSubclass#{ Time.now.to_i.to_s }".to_sym
    m          = Module.new
    m.const_set klass_name , Class.new( ::DogWalker ){ attr_accessor :bogus }
    m.const_get klass_name
  end
end
