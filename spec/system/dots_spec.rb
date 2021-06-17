require 'rails_helper'

RSpec.describe "新規投稿", type: :system do
  before do
    @user = FactoryBot.create(:user)
    @dot = FactoryBot.build(:dot)
  end

  context '新規投稿できるとき' do
    it 'ログインしたユーザーは新規投稿できる' do
      # ログインする
      sign_in(@user)
      # 新規投稿ページへのボタンがあることを確認する
      expect(page).to have_content('New Dot')
      # 投稿ページに移動する
      visit new_dot_path
      # フォームに情報を入力する
      fill_in 'dot_title', with: @dot.title
      select '日々の授業', from: 'dot_category_id'
      fill_in 'dot_content', with: @dot.content
      # 送信するとDotモデルのカウントが1上がることを確認する      
      expect{
        find('input[name="commit"]').click
      }.to change{Dot.count}.by(1)
      # トップページに遷移することを確認する
      expect(current_path).to eq(root_path)
      # トップページには先ほど投稿した内容が存在することを確認する
      expect(page).to have_content(@dot.title)
      expect(page).to have_content(@dot.created_at)
    end
  end

  context '新規投稿ができないとき' do
    it 'ログインしていないと新規投稿ページに遷移できない' do
      # トップページに遷移する
      visit root_path
      # 新規投稿ページへのボタンがないことを確認する
      expect(page).to have_no_content('New Dot')
    end
  end
end
