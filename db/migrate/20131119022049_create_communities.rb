class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :name
      t.string :nickname
      t.string :slug
      t.string :type

      t.timestamps
    end
  end
end
