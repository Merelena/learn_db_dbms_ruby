class CreateEduInstitutions < ActiveRecord::Migration[6.1]
  def change
    create_table :edu_institutions do |t|
      t.string :edu_institution
      t.string :city

      t.timestamps
    end
  end
end
