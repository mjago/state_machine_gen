class CreateStates < ActiveRecord::Migration
  def self.up
    create_table :states do |t|
      t.string :project
      t.string :device
      t.string :module
      t.string :from
      t.string :to
      t.string :transition
      t.datetime :date

      t.timestamps
    end
  end

  def self.down
    drop_table :states
  end
end
