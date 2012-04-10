class DogWalker < ActiveRecord::Base
  has_many :dogs , :autosave => true
end
