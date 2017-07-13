class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :title
      t.string :content
      t.string :image
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
