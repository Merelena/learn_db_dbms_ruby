class EduInstitutionUniqueName < ActiveRecord::Migration[6.1]
  def change
    add_index :edu_institutions, :edu_institution, :unique => true
  end
end
