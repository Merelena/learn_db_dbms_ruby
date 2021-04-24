class CreateEduAids < ActiveRecord::Migration[6.1]
  def change
    create_table :edu_aids do |t|
      t.string :name,              null: false
      t.string :authors,           null: false
      t.string :publisher,         null: false
      t.integer :publish_year,     null: false
      t.string :document,          null: false
      t.string :description,       null: true
      t.integer :number_of_pages,  null: true
      t.string :image,             null: true, default: ""
      

      t.references :user, foreign_key: { to_table: :users }, index: true
      t.timestamps
    end
  end
end
