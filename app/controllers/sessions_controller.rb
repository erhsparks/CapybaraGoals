class SessionsController < ApplicationController
  def new
  end

  def create
    result = User.find_by_credentials(user_params)

    if result.is_a?(User)
      user = result
      login!(user)

      redirect_to user_url(user)
    else
      flash[:errors] = result

      redirect_to new_session_url
    end
  end

  def destroy
    logout!

    redirect_to new_session_url
  end

  private
  def user_params
    params.require(:user).permit(:username, :password)
  end
end
