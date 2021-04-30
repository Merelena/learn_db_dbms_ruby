class EduInstitution < ApplicationRecord
  has_many :users, dependent: :destroy
end
