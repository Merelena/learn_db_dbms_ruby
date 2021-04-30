class CreateResponses < ActiveRecord::Migration[6.1]
  def change
    create_table :responses do |t|
      t.string :response, null: false
      t.integer :order,   null: false
      t.boolean :correct, null: false
      t.references :question, foreign_key: { to_table: :questions }, index: true
      t.timestamps
    end
  end
end
