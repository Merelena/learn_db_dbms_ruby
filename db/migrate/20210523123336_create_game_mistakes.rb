class CreateGameMistakes < ActiveRecord::Migration[6.1]
  def change
    create_table :game_mistakes do |t|
      t.string :correct_task, null: false
      t.string :incorrect_task, null: false
      t.timestamps
    end
  end
end
