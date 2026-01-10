class Founder::AccountController < Founder::BaseController
  def show
  end

  def edit
  end

  def update
    user_attrs = params.require(:user).permit(:email, :password, :password_confirmation)
    profile_attrs = params.require(:user).fetch(:user_profile, {}).permit(:full_name, :bio, :city, :country, :professional_website)

    success = true
    success &= current_user.update(user_attrs) if user_attrs.present?

    if profile_attrs.present?
      profile = current_user.user_profile || current_user.build_user_profile
      success &= profile.update(profile_attrs)
    end

    respond_to do |format|
      if success
        format.html { redirect_to founder_account_path, notice: "Account updated." }
        format.js { render json: { message: "Account updated." }, status: :ok }
      else
        format.html { render :edit }
        format.js { render json: { errors: (profile&.errors&.full_messages || []) + (current_user.errors.full_messages || []) }, status: :unprocessable_entity }
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
