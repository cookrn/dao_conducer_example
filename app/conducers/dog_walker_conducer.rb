class DogWalkerConducer < Dao::Conducer
  DOG_WALKER_FIELDS_WHITELIST = %w( name )
  DOG_FIELDS_WHITELIST        = DOG_WALKER_FIELDS_WHITELIST.dup

  def initialize( dog_walker , params = {} )
    @dog_walker = dog_walker

    setup_validations!

    update_attributes @dog_walker.to_map( true )
    update_attributes params
  end

  def save
    ## Update the DogWalker
    #
      DOG_WALKER_FIELDS_WHITELIST.each do | field |
        field_val = attributes.get field
        @dog_walker.send( "#{ field }=".to_sym , field_val ) if field_val.present?
      end

    ## Update the Dogs
    #
      dogs_attributes = attributes.get( :dogs ) || []
      dogs_attributes.each do | dog_attributes |
        dog = case
              when dog_attributes.include?( :id )
                @dog_walker.dogs.detect { | d | d.id.to_s == dog_attributes.get( :id ).to_s }
              else
                @dog_walker.dogs.build
              end

        DOG_FIELDS_WHITELIST.each do | field |
          field_val = dog_attributes.get field
          dog.send( "#{ field }=".to_sym , field_val ) if field_val.present?
        end
      end

    if @dog_walker.save
      update_attributes @dog_walker.to_map( true )
      true
    else
      @dog_walker.errors.full_messages.each { | msg | @errors.add msg }
      false
    end
  end

  def setup_validations!
    validates_presence_of :name
    validates_each :dogs do
      validates_presence_of :name
    end
  end
end
