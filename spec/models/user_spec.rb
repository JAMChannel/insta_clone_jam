require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it 'ユーザー名は必須であること' do
      # user = User.new(username: '"森田 玲奈"', email: 'carey@wisoky.co', password: '12345678', password_confirmation: '12345678')
      # user.valid?
      user = build(:user, username: nil)
      user.valid?
      expect(user.errors[:username]).to include('を入力してください')
    end

    it 'ユーザー名は一意であること' do
      user = create(:user)
      same_name_user = build(:user, username: user.username)
      same_name_user.valid?
      expect(same_name_user.errors[:username]).to include('はすでに存在します')
    end

    it 'メールアドレスは必須であること' do
      user = build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include('を入力してください')
    end

    it 'メールアドレスは一意であること' do
      user = create(:user)
      same_email_user = build(:user, email: user.email)
      same_email_user.valid?
      expect(same_email_user.errors[:email]).to include('はすでに存在します')
    end

    it 'passwordとpassword_confirmationが不一致では登録できないこと' do
      user = create(:user)
      user.password = '123456'
      user.password_confirmation = '123465'
      user.valid?
      expect(user.errors.full_messages).to include("パスワード確認とパスワードの入力が一致しません")
    end

  end

  describe 'インスタンスメソッド' do
    let(:user_a) { create(:user) }
    # before do
    #   @user_a = FactoryBot.create(:user)
    # end
    # binding.pry
    let(:user_b) { create(:user) }
    let(:user_c) { create(:user) }

    describe 'like' do
      it 'フォローできること' do
        expect { user_a.follow(user_b) }.to change { Relationship.count }.by(1)
        # binding.pry
      end
    end

    describe 'unlike' do
      it 'フォローを外せること' do
        user_a.follow(user_b)
        expect { user_a.unfollow(user_b) }.to change { Relationship.count }.by(-1)
      end
    end

    describe 'unlike' do
      it 'フォローを外せること' do
        user_a.follow(user_b)
        expect { user_a.unfollow(user_b) }.to change { Relationship.count }.by(-1)
      end
    end

    describe 'following?' do
      context 'フォローしている場合' do
        it 'trueを返す' do
          user_a.follow(user_b)
          expect(user_a.following?(user_b)).to be true
        end
      end

      context 'フォローしていない場合' do
        it 'falseを返す' do
          expect(user_a.following?(user_b)).to be false
        end
      end
    end

  end

end