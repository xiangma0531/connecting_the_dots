require 'rails_helper'

RSpec.describe "ユーザー新規登録", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  context 'ユーザー新規登録ができるとき' do
    it '正しい情報を入力すればユーザー新規登録ができトップページに移動する' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録画面へ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_name', with: @user.name
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      fill_in 'user_password_confirmation', with: @user.password_confirmation
      # 新規登録ボタンをクリックするとUserモデルのカウントが1上がることを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{User.count}.by(1)
      # トップページへ遷移したことを確認する
      expect(current_path).to eq(root_path)
      # 現在のユーザー名が表示されていることを確認する
      expect(page).to have_content(@user.name)
      # ログインボタンや新規登録ページへの遷移ボタンが表示されていないことを確認する
      expect(page).to have_no_content('ログイン')
      expect(page).to have_no_content('新規登録')
    end
  end

  context 'ユーザー新規登録ができないとき' do
    it '誤った情報ではユーザー新規登録ができずに新規登録ページへ戻ってくる' do
      # トップページに移動する
      visit root_path
      # トップページに新規登録ページへ遷移するボタンがあることを確認する
      expect(page).to have_content('新規登録')
      # 新規登録ページへ移動する
      visit new_user_registration_path
      # ユーザー情報を入力する
      fill_in 'user_name', with: ''
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      fill_in 'user_password_confirmation', with: ''
      # 新規登録ボタンをクリックしてもUserモデルのカウントは上がらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{User.count}.by(0)
      # 新規登録ページへ戻されることを確認する
      expect(current_path).to eq(user_registration_path)
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('3 件のエラーが発生したため ユーザー は保存されませんでした。')
      expect(page).to have_content('Eメールを入力してください')
      expect(page).to have_content('パスワードを入力してください')
      expect(page).to have_content('名前を入力してください')
    end
  end
end

RSpec.describe "ログイン機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ログインできるとき' do
    it '保存されているユーザーの情報と一致すればログインできる' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # 正しいユーザー情報を入力する
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: @user.password
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # トップページへ遷移することを確認する
      expect(current_path).to eq(root_path)
      # ログインページや新規登録ページへ遷移するボタンが表示されていないことを確認する
      expect(page).to have_no_content('ログイン')
      expect(page).to have_no_content('新規登録')
    end
  end

  context 'ログインできないとき' do
    it '保存されているユーザーの情報と一致しないとログインができない' do
      # トップページに移動する
      visit root_path
      # トップページにログインページへ遷移するボタンがあることを確認する
      expect(page).to have_content('ログイン')
      # ログインページへ遷移する
      visit new_user_session_path
      # ユーザー情報を入力する
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: ''
      # ログインボタンをクリックする
      find('input[name="commit"]').click
      # ログインページへ戻されることを確認する
      expect(current_path).to eq(new_user_session_path)
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content('Eメールまたはパスワードが違います。')
    end
  end
end

RSpec.describe "ユーザー情報編集機能", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'ユーザー情報を編集できるとき' do
    it '必要な情報を正しく入力すればユーザー情報を編集できる' do
      # ログインする
      sign_in(@user)
      # ユーザー情報編集ページへ遷移する
      visit edit_user_registration_path
      # 現在のユーザー情報が入力されていることを確認する
      expect(
        find('#user_name').value
      ).to eq(@user.name)
      expect(
        find('#user_email').value
      ).to eq(@user.email)
      # 入力する
      fill_in 'user_name', with: "#{@user.name}+編集しました"
      fill_in 'user_current_password', with: @user.password
      # 「更新」ボタンをクリックしてもUserモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{User.count}.by(0)
      # トップページに遷移したことを確認する
      expect(current_path).to eq(root_path)
      # 編集した名前が表示されていることを確認する
      expect(page).to have_content("#{@user.name}+編集しました")
    end
  end

  context 'ユーザー情報が編集できないとき' do
    it '現在のパスワードを入力しなければユーザー情報は編集できず、エラーメッセージが表示される' do
      # ログインする
      sign_in(@user)
      # ユーザー情報編集ページへ遷移する
      visit edit_user_registration_path
      # 現在のユーザー情報が入力されていることを確認する
      expect(
        find('#user_name').value
      ).to eq(@user.name)
      expect(
        find('#user_email').value
      ).to eq(@user.email)
      # 入力する
      fill_in 'user_name', with: ''
      fill_in 'user_email', with: ''
      fill_in 'user_current_password', with: ''
      # 「更新」ボタンをクリックしてもUserモデルのカウントは変わらないことを確認する
      expect{
        find('input[name="commit"]').click
      }.to change{User.count}.by(0)
      # ユーザー情報編集ページへ戻されていることを確認する
      expect(current_path).to eq(user_registration_path)
      # エラーメッセージが表示されていることを確認する
      expect(page).to have_content("3 件のエラーが発生したため ユーザー は保存されませんでした。")
      expect(page).to have_content("Eメールを入力してください")
      expect(page).to have_content("名前を入力してください")
      expect(page).to have_content("現在のパスワードを入力してください")
    end

    it 'ログインしていなければユーザー情報は編集できない' do
      # トップページにいる
      visit root_path
      # ユーザー情報編集ページへのリンクが存在しないことを確認する
      expect(page).to have_no_link('ユーザー情報編集', href: edit_user_registration_path)
    end
  end
end