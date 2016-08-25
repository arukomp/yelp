class Restaurant < ActiveRecord::Base
  include DestroyWithUserExtension
  belongs_to :user
  has_many :reviews,
    -> { extending WithUserAssociationExtension },
    dependent: :destroy
  validates :name, length: { minimum: 3 }, uniqueness: true
end
