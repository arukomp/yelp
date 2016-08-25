class Restaurant < ActiveRecord::Base

  belongs_to :user
  has_many :reviews,
    -> { extending WithUserAssociationExtension },
    dependent: :destroy
  validates :name, length: { minimum: 3 }, uniqueness: true

  def destroy_with_user(user)
    return false if self.user != user
    destroy
  end
  # def build_review(attributes = {}, user)
  #   review = reviews.build(attributes)
  #   review.user = user
  #   return review
  # end
end
