class UsersController < ApplicationController
  def index
    @dots = current_user.dots.order("created_at DESC")
  end
end
