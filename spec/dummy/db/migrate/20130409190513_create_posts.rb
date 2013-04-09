class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.hstore :title
      t.hstore :content
      t.string :author

      t.timestamps
    end
    add_hstore_index :posts, :title
    add_hstore_index :posts, :content
  end
end
