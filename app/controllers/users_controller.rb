class UsersController < ApplicationController
  before_action :authenticate_user!, except: :index

  def index
    if user_signed_in? 
      @dots = current_user.dots.order("created_at DESC")
    end
  end
end
