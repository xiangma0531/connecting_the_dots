class DotsController < ApplicationController

  def new
    @dot = Dot.new
  end

  def create
    @dot = Dot.new(dot_params)
    if @dot.save
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @dot = Dot.find(params[:id])
  end

  private
  def dot_params
    params.require(:dot).permit(:title, :category_id, :content).merge(user_id: current_user.id)
  end

end
