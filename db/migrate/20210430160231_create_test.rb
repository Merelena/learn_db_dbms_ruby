class CreateTest < ActiveRecord::Migration[6.1]
  def change
    create_table :tests do |t|
      t.string :name, null: false
      t.references :user, foreign_key: { to_table: :users }, index: true
      t.timestamps
    end
  end
end
