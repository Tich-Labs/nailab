class Founder::AccountController < Founder::BaseController
  def show
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to founder_account_path, notice: "Account updated."
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, user_profile_attributes: [ :first_name, :last_name, :phone, :country, :city ])
  end
end
