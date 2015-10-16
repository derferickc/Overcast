class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.references :playlist, index: true
      t.references :track, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
