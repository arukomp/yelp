class Review < ActiveRecord::Base
  include DestroyWithUserExtension
  has_many :endorsements, dependent: :destroy
  belongs_to :restaurant
  belongs_to :user
  validates :rating, inclusion: (1..5)
  validates :user, uniqueness: { scope: :restaurant, message: "has reviewed this restaurant already"}
end
