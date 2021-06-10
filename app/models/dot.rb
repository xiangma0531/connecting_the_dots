class Dot < ApplicationRecord
  belongs_to :user

  with_options presence: true do
    validates :title
    validates :category_id
    validates :content
  end

  extend ActiveHash::Associations::ActiveRecordExtensions
  belongs_to :category
end
