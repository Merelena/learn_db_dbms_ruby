class DeleteSomeQuestionsFields < ActiveRecord::Migration[6.1]
  def change
    remove_column :questions, :response
    remove_column :questions, :correct
    remove_column :questions, :order
  end
end
