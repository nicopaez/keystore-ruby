class CreateNotes < ActiveRecord::Migration
  def up
    create_table :notes do |t|
      t.string :user
      t.string :key
      t.string :value
    end
  end

  def down
    drop_table :notes
  end
end
