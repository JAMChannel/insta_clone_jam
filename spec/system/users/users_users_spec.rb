require 'rails_helper'

# let!(:user) 

RSpec.describe 'ユーザー登録', type: :system do
  # before do
  #   @user = FactoryBot.build(:user)
  # end
  let!(:user) { build(:user) }
  context '入力情報が正しい場合' do
    it 'ユーザー登録ができること' do
       # 新規登録ページへ移動する
       visit new_user_path
      #  fill_in 'ユーザー名', with: 'Rails太郎' ,match: :first
      #  fill_in 'メールアドレス', with: 'rails@example.com'
      #  fill_in 'パスワード', with: '12345678'
      #  fill_in 'パスワード確認', with: '12345678'
       fill_in 'ユーザー名', with: user.username
       fill_in 'メールアドレス', with: user.email
       fill_in 'パスワード', with: user.password
       fill_in 'パスワード確認', with: user.password_confirmation
       click_button '登録'
      #  expect{
      #   find('input[name="commit"]').click
      # }.to change { User.count }.by(1)
       expect(current_path).to eq login_path
       expect(page).to have_content 'ユーザーを作成しました'
    end
  end

  context '入力情報に誤りがある場合' do
    it 'ユーザー登録に失敗すること' do
      visit new_user_path
      fill_in 'ユーザー名', with: ''
      fill_in 'メールアドレス', with: ''
      fill_in 'パスワード', with: ''
      fill_in 'パスワード確認', with: ''
      click_button '登録'
      expect(page).to have_content 'ユーザー名を入力してください'
      expect(page).to have_content 'メールアドレスを入力してください'
      expect(page).to have_content 'パスワードは3文字以上で入力してください'
      expect(page).to have_content 'パスワード確認を入力してください'
      expect(page).to have_content 'ユーザーの作成に失敗しました'
    end
  end

  describe 'フォロー' do
    let!(:login_user) { create(:user) }
    let!(:other_user) { create(:user) }

    before do
      login_as login_user
    end
    it 'フォローができること' do
      visit posts_path
      expect {
        within "#follow-area-#{other_user.id}" do
          click_link 'フォロー'
          expect(page).to have_content 'アンフォロー'
        end
      }.to change(login_user.following, :count).by(1)
    end

    it 'フォローを外せること' do
      login_user.follow(other_user)
      visit posts_path
      expect {
        within "#follow-area-#{other_user.id}" do
          click_link 'アンフォロー'
          expect(page).to have_content 'フォロー'
        end
      }.to change(login_user.following, :count).by(-1)
    end
  end
end


# RSpec.describe "Users::Users", type: :system do
#   before do
#     driven_by(:rack_test)
#   end

#   pending "add some scenarios (or delete) #{__FILE__}"
# end
