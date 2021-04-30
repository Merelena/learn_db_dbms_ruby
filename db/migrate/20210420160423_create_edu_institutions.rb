class CreateEduInstitutions < ActiveRecord::Migration[6.1]
  def change
    create_table :edu_institutions do |t|
      t.string :edu_institution
      t.string :city
      Users.create!(email: "nastya@vovna.com", password: "02481012", role: "superadmin", first_name: "Анастасия", last_name: "Вовна", edu_institution: "МРК")
      t.timestamps
    end
  end
end
