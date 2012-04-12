class DogWalkerConducer < Dao::Conducer
  DOG_WALKER_FIELDS_WHITELIST = %w( name )
  DOG_FIELDS_WHITELIST        = DOG_WALKER_FIELDS_WHITELIST.dup

  validates_presence_of :name
  validates_each :dogs do
    validates_presence_of :name
  end

  ## Caveat
  #
  # The default initializer in Dao::Conducer should handle the cases specified below
  # We are overriding it for clarity
  #
  def initialize( dog_walker , params = {} )
    @dog_walker = dog_walker

    update_attributes @dog_walker.to_map( true )
    update_attributes params
  end

  def display_attribute_value( val )
    if val.class.ancestors.include?( Enumerable )
      val.size
    else
      val
    end
  end

  def save
    update_dog_walker!
    update_dogs!

    if valid? and @dog_walker.save
      update_attributes @dog_walker.to_map( true )
      true
    else
      @dog_walker.errors.full_messages.each { | msg | @errors.add msg }
      false
    end
  end

  def update_dog_walker!( *args )
    opts       = Map.opts! args
    dog_walker = opts.dog_walker rescue @dog_walker
    attributes = opts.attributes rescue self.attributes

    DOG_WALKER_FIELDS_WHITELIST.each do | field |
      field_val = attributes.get field
      dog_walker.send( "#{ field }=".to_sym , field_val ) unless field_val.blank?
    end
  end

  def update_dogs!( *args )
    opts       = Map.opts! args
    dogs       = opts.dogs       rescue @dog_walker.dogs
    attributes = opts.attributes rescue self.attributes

    dogs_attributes = attributes.get( :dogs ) || []
    dogs_attributes.each do | dog_attributes |
      dog = case
            when dog_attributes.include?( :id )
              dogs.detect { | d | d.id.to_s == dog_attributes.get( :id ).to_s }
            else
              dogs.build
            end

      DOG_FIELDS_WHITELIST.each do | field |
        field_val = dog_attributes.get field
        dog.send( "#{ field }=".to_sym , field_val ) unless field_val.blank?
      end
    end
  end
end
