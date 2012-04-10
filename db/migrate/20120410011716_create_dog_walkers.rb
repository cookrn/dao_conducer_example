class CreateDogWalkers < ActiveRecord::Migration
  def change
    create_table :dog_walkers do | t |
      t.string :name
      t.timestamps
    end
  end
end
