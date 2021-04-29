class DeleteOrderForResponse < ActiveRecord::Migration[6.1]
  def change
    remove_column :responses, :order
  end
end
