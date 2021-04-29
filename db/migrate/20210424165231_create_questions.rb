class CreateQuestions < ActiveRecord::Migration[6.1]
  def change
    create_table :questions do |t|
      t.string :question, null: false
      t.string :response, null: false
      t.integer :order,   null: false
      t.boolean :correct, null: false
      t.references :test, foreign_key: { to_table: :tests }, index: true
      t.timestamps
    end
  end
end
