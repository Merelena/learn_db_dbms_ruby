# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.firs
Edu_institution.create!(name: "БГУИР", city: "Минск")
User.create!(email: "ivan@ivanov.com", password: "0234810", first_name: "Иван", last_name: "Иванов", role: "superadmin", edu_institution: 1)