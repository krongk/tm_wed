class CreateResourceMusics < ActiveRecord::Migration
  def change
    create_table :resource_musics do |t|
      t.references :user, index: true
      t.references :member, index: true
      t.string :name
      t.string :url

      t.timestamps
    end
    add_attachment :resource_musics, :asset
  end
end
