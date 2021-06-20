module SignInSupport
  def sign_in(user)
    # トップページに移動する
    visit root_path
    # トップページにログインページへ遷移するボタンがあることを確認する
    expect(page).to have_content('ログイン')
    # ログインページへ遷移する
    visit new_user_session_path
    # 正しいユーザー情報を入力する
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    # ログインボタンを押す
    find('input[name="commit"]').click
    # トップページへ遷移することを確認する
    expect(current_path).to eq(root_path)
    # 現在のユーザーの名前が表示されている
    expect(page).to have_content(user.name)
    # ログイン画面や新規登録画面への遷移するボタンが表示されていない
    expect(page).to have_no_content('ログイン')
    expect(page).to have_no_content('新規登録')
  end
end