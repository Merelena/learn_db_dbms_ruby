class EduAid < ApplicationRecord
  mount_uploader :image, ImageUploader
  mount_uploader :document, DocumentUploader
  PerPage = 10
  def self.page(pg)
    pg = pg.to_i
    self.offset((pg-1)*PerPage).limit(PerPage)
  end

  def self.pgcount
    count % PerPage == 0 ? count / PerPage : count / PerPage + 1
  end
end
