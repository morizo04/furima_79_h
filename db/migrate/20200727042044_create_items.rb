class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :name, null: false
      t.text :introduction, null: false
      t.integer :price, null: false
      t.string :brand
      t.integer :condition_id, null: false, foreign_key: true  #active_hashを使用
      t.integer :postagepayer_id, null: false, foreign_key: true  #active_hashを使用
      t.integer :prefecture_id, null: false  #active_hashを使用
      # t.integer :size_id, null: false, foreign_key: true  #active_hashを使用
      t.integer :preparationday_id, null: false, foreign_key: true  #active_hashを使用
      # t.integer :postagetype_id, null: false, foreign_key: true  #active_hashを使用
      # t.references :item_image, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.references :user, index: true, foreign_key: true
      # t.integer :trading_status, null: false  #active_hashを使用
      t.integer :buyer_id


      t.timestamps
    end
  end
end
