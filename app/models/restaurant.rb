class Restaurant < ActiveRecord::Base
  # belongs_to :user
  has_many :reviews,
      -> { extending WithUserAssociationExtension },
      dependent: :destroy
  validates :name, length: { minimum: 3 }, uniqueness: true

  # def build_review(review_params={}, user)
  #   review = reviews.build(review_params)
  #   review.user = user
  #   review
  # end

end
