class UsersController < ApplicationController

  before_action :set_user, only: [:finish_signup]

  def finish_signup
    if @user.update(user_params)
      sign_in(@user, :bypass => true)
      redirect_to root_path, notice: 'Your profile was successfully updated.'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email)
  end
end
