class Founder::AccountController < Founder::BaseController
  def show
  end

  def edit
  end

  def update
    user_attrs = params.require(:user).permit(:email, :password, :password_confirmation)
    profile_attrs = params.require(:user).fetch(:user_profile, {}).permit(
      :full_name, :bio, :city, :country, :professional_website, :photo,
      :photo_visibility, :linkedin_url, :twitter_url, :other_social_url, :other_social_platform
    )

    success = true
    success &= current_user.update(user_attrs) if user_attrs.present?

    if profile_attrs.present?
      profile = current_user.user_profile || current_user.build_user_profile
      # Handle boolean checkbox for photo visibility
      profile_attrs[:photo_visibility] = true if profile_attrs[:photo_visibility] == "true"

      # Handle attached photo separately to ensure ActiveStorage attaches correctly
      photo = profile_attrs.delete(:photo)
      success &= profile.update(profile_attrs)
      if photo.present?
        begin
          profile.photo.attach(photo)
        rescue => e
          profile.errors.add(:photo, "upload failed: #{e.message}")
          success = false
        end
      end
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

  def destroy
    # Store user reference and record deleted email for informational login checks
    user = current_user
    DeletedAccount.create!(email: user.email) rescue nil

    # Sign out the user first and then destroy the account
    sign_out user
    user.destroy

    respond_to do |format|
      format.html { redirect_to root_path, notice: "Your account has been successfully deleted. We're sorry to see you go!" }
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
