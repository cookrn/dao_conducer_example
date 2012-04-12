class DogWalkersController < ApplicationController
  def create
    @conducer = DogWalkerConducer.for(
      :create,
      DogWalker.new,
      params[ :dog_walker ]
    )
  end

  def edit
    @conducer = DogWalkerConducer.for(
      :edit,
      DogWalker.find( params[ :id ] )
    )
  end

  def index
    @dog_walkers = DogWalker.all.map! do | walker |
      DogWalkerConducer.for(
        :show,
        walker
      )
    end
  end

  def new
    @conducer = DogWalkerConducer.for(
      :new,
      DogWalker.new
    )
  end

  def show
    @conducer = DogWalkerConducer.for(
      :show,
      DogWalker.find( params[ :id ] )
    )
  end

  def update
    @conducer = DogWalkerConducer.for(
      :update,
      DogWalker.find( params[ :id ] ),
      params[ :dog_walker ]
    )
  end
end
