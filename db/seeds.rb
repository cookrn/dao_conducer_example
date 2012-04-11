dog_walker = DogWalker.new :name => "Johnny Cash"

3.times do | i |
  dog_walker.dogs.build :name => "Doggy #{ i }"
end

dog_walker.save!
