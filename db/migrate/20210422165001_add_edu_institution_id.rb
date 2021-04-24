class AddEduInstitutionId < ActiveRecord::Migration[6.1]
  def self.up
    change_table :users do |t|
      ## Database authenticatable
      t.references :edu_institution, foreign_key: { to_table: :edu_institutions }, index: true
    end
  end
end
