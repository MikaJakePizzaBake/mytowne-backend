class Tag < ApplicationRecord
  #Associations
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags, dependent: :destroy

  #Validations
  validates :name, presence: true, uniqueness: true

end
