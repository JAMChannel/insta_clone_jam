require 'rails_helper'

RSpec.describe 'チャット', type: :system do
  let(:login_user) { create(:user) }
  let(:user) { create(:user) }
  # OJT課題用なのでdescribeやcontextも書かない方がわかりやすいと思ったのであえてそうしている。

  it 'ユーザーの詳細ページに「メッセージ」ボタンが存在すること' do
    # ログインする
    login_as login_user
    # ユーザーの詳細画面に遷移する
    visit user_path(user)
    # メッセージボタンが存在する
    expect(page).to have_selector(:link_or_button, 'メッセージ')
  end

  it '「メッセージ」ボタンを押すと当該ユーザーとのチャットルームに遷移すること' do
    # ログインする
    login_as login_user
    # ユーザーの詳細画面に遷移する
    visit user_path(user)
    # メッセージボタンを押す
    click_on 'メッセージ'
    expect(current_path).to eq chatroom_path(Chatroom.first)
  end

  it 'テキストを入力して投稿ボタンを押すとメッセージが投稿されること' do
    # ログインする
    login_as login_user
    # ユーザーの詳細画面に遷移する
    visit user_path(user)
    # メッセージボタンを押す
    click_on 'メッセージ'
    # メッセージを入力する
    fill_in 'メッセージ', with: 'hello world'
    # 投稿ボタンを押す
    click_on '投稿'
  end


end