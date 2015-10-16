class CreateListeners < ActiveRecord::Migration
  def change
    create_table :listeners do |t|
      t.references :playlist, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
