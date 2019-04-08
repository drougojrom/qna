class UsersController < ApplicationController

  before_action :set_user, only: [:finish_signup, :profile]

  def finish_signup
    if request.patch? && params[:user][:email]
      if @user.update(user_params)
        @user.send_confirmation_instructions
        redirect_to root_path, notice: 'Confirm your email'
      end
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
