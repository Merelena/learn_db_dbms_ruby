class EduAidDocumentNull < ActiveRecord::Migration[6.1]
  def change
    change_table :edu_aids do |t|
      t.change :document, :string, null: true
    end
  end
end
