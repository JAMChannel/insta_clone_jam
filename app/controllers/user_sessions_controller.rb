class UserSessionsController < ApplicationController
  def new; end

  def create
    @user = login(params[:email], params[:password])
    if @user
      # ActionCableでユーザーを特定するために必要
      cookies.signed['user.id'] = current_user.id
      redirect_back_or_to root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    cookies.delete('user.id')
    redirect_to login_path, success: 'ログアウトしました'
  end
end
