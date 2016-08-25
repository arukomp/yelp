module DestroyWithUserExtension
  def destroy_with_user(user)
    return false if self.user != user
    destroy
  end
end
