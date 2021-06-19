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

RSpec.describe "Dot編集", type: :system do
  before do
    @dot1 = FactoryBot.create(:dot)
    @dot2 = FactoryBot.create(:dot)
  end

  context 'Dot編集ができるとき' do
    it 'ログインしたユーザーは自分が作成したDotの編集ができる' do
      # Dot1を作成したユーザーでログインする
      sign_in(@dot1.user)
      # Dot1が表示されていることを確認する
      expect(page).to have_content(@dot1.title)
      # Dot1のタイトルをクリックする
      find_link(@dot1.title, href: dot_path(@dot1)).click
      # Dot1の詳細ページに遷移したことを確認する
      expect(current_path).to eq(dot_path(@dot1))
      # Dot1の詳細ページに「編集」へのリンクがあることを確認する
      expect(page).to have_link '編集', href: edit_dot_path(@dot1)
      # 編集ページへ遷移する
      visit edit_dot_path(@dot1)
      # すでに作成済みの内容がフォームに入っていることを確認する
      expect(
        find('#dot_title').value
      ).to eq(@dot1.title)
      expect(
        find('#dot_category_id').value
      ).to eq("#{@dot1.category_id}")
      expect(
        find('#dot_content').value
      ).to eq(@dot1.content)
      # 投稿内容を編集する
      fill_in 'dot_title', with: "#{@dot1.title}+編集したタイトル"
      select '家庭学習', from: 'dot_category_id'
      fill_in 'dot_content', with: "#{@dot1.content}+編集したcontent"
      # 編集してもDotモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{Dot.count}.by(0)
      # 詳細ページに遷移することを確認する
      expect(current_path).to eq(dot_path(@dot1))
      # 詳細ページには先ほど変更した内容のDotが表示されていることを確認する
      expect(page).to have_content("#{@dot1.title}+編集したタイトル")
      expect(page).to have_content('家庭学習')
      expect(page).to have_content("#{@dot1.content}+編集したcontent")
      # トップページに移動する
      visit root_path
      # トップページには先ほど変更したタイトルのDotが表示されていることを確認する
      expect(page).to have_content("#{@dot1.title}+編集したタイトル")
    end
  end

  context 'Dot編集ができないとき'
    it 'ログインしたユーザーは自分以外が作成したDotの編集画面には遷移できない' do
      # Dot1を作成したユーザーでログインする
      sign_in(@dot1.user)
      # Dot2は表示されていないことを確認する
      expect(page).to have_no_content(@dot2.title)
    end

    it 'ログインしていないとDotの編集画面には遷移できない' do
      # トップページにいる
      visit root_path
      # Dot1が表示されていないことを確認する
      expect(page).to have_no_content(@dot1.title)
      # Dot2が表示されていないことを確認する
      expect(page).to have_no_content(@dot2.title)
    end
end

RSpec.describe "Dot削除", type: :system do
  before do
    @dot1 = FactoryBot.create(:dot)
    @dot2 = FactoryBot.create(:dot)
  end
  context 'Dot削除ができるとき' do
    it 'ログインしたユーザーは自らが作成したDotの削除ができる' do
      # Dot1を作成したユーザーでログインする
      sign_in(@dot1.user)
      # Dot1が表示されていることを確認する
      expect(page).to have_content(@dot1.title)
      # Dot1のタイトルをクリックする
      find_link(@dot1.title, href: dot_path(@dot1)).click
      # Dot1の詳細ページに遷移したことを確認する
      expect(current_path).to eq(dot_path(@dot1))
      # Dot1の詳細ページに「削除」リンクがあることを確認する
      expect(page).to have_link('削除', href: dot_path(@dot1))
      # Dot1を削除するとレコードの数が1減ることを確認する
      expect{
        find_link('削除', href: dot_path(@dot1)).click
      }.to change{Dot.count}.by(-1)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # トップページにはDot1の内容が存在しないことを確認する
      expect(page).to have_no_content(@dot1.title)
    end
  end

  context 'Dot削除ができないとき' do
    it 'ログインしたユーザーは自分以外が作成したDotの削除ができない' do
      # Dot1を作成したユーザーでログインする
      sign_in(@dot1.user)
      # Dot2の内容が存在しないことを確認する
      expect(page).to have_no_content(@dot2.title)
    end

    it 'ログインしていないとDot削除ができない' do
      # トップページにいる
      visit root_path
      # Dot1が表示されていないことを確認する
      expect(page).to have_no_content(@dot1.title)
      # Dot2が表示されていないことを確認する
      expect(page).to have_no_content(@dot2.title)
    end
  end
end