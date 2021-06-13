class DotsController < ApplicationController
  before_action :move_to_index, except: [:new, :create]
  before_action :set_dot, only: [:show, :edit, :update]

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
  end

  def edit
  end

  def update
    if @dot.update(dot_params)
      redirect_to dot_path(@dot.id)
    else
      render :edit
    end
  end

  def destroy
    dot = Dot.find(params[:id])
    dot.destroy
    redirect_to root_path
  end

  private
  def dot_params
    params.require(:dot).permit(:title, :category_id, :content).merge(user_id: current_user.id)
  end

  def set_dot
    @dot = Dot.find(params[:id])
  end

  def move_to_index
    dot = Dot.find(params[:id])
    unless dot.user_id == current_user.id
      redirect_to root_path 
    end
  end

end
