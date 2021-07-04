class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = 'ユーザー登録が完了しました'
    else
      flash[:danger] = '無効な有効化リンクです'
    end
    redirect_to root_url
  end
end
