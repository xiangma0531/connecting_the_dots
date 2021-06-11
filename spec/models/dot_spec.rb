require 'rails_helper'

RSpec.describe Dot, type: :model do
  describe '#create' do
    before do
      @dot = FactoryBot.build(:dot)
    end

    context '新規投稿できるとき' do
      it 'すべての項目が正しく入力できていれば新規投稿できる' do
        expect(@dot).to be_valid
      end
    end

    context '新規投稿できないとき' do
      it 'titleが空では新規投稿できない' do
        @dot.title = ''
        @dot.valid?
        expect(@dot.errors.full_messages).to include("Title can't be blank")
      end

      it 'categoryが空では新規登録できない' do
        @dot.category_id = nil
        @dot.valid?
        expect(@dot.errors.full_messages).to include("Category can't be blank")
      end

      it 'contentが空では新規投稿できない' do
        @dot.content = ''
        @dot.valid?
        expect(@dot.errors.full_messages).to include("Content can't be blank")
      end

      it 'userが紐づいていないと新規投稿できない' do
        @dot.user = nil
        @dot.valid?
        expect(@dot.errors.full_messages).to include("User must exist")
      end
    end
  end
end
