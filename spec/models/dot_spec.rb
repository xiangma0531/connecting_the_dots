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
        expect(@dot.errors.full_messages).to include("タイトルを入力してください")
      end

      it 'categoryが空では新規登録できない' do
        @dot.category_id = nil
        @dot.valid?
        expect(@dot.errors.full_messages).to include("カテゴリーを入力してください")
      end

      it 'contentが空では新規投稿できない' do
        @dot.content = ''
        @dot.valid?
        expect(@dot.errors.full_messages).to include("メモを入力してください")
      end

      it 'userが紐づいていないと新規投稿できない' do
        @dot.user = nil
        @dot.valid?
        expect(@dot.errors.full_messages).to include("Userを入力してください")
      end
    end
  end
end
