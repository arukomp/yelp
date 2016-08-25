describe User do
  it "has many reviewed restaurants" do
    is_expected.to have_many :reviewed_restaurants
  end
end
