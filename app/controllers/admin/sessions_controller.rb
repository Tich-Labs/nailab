class Admin::SessionsController < ApplicationController
  # Render the standard Devise sign-in form so we don't duplicate markup.
  def new
    # Provide Devise view helpers expected by the shared Devise templates.
    @resource = User.new
    @resource_name = :user
    @devise_mapping = Devise.mappings[:user]

    # Render the existing Devise sessions view (prefer app override if present)
    if lookup_context.exists?("users/sessions/new")
      render "users/sessions/new", locals: { resource: @resource, resource_name: @resource_name, devise_mapping: @devise_mapping }
    else
      render "devise/sessions/new", locals: { resource: @resource, resource_name: @resource_name, devise_mapping: @devise_mapping }
    end
  end

  # Authenticate and only allow users with admin role to sign in via this path.
  def create
    email = params.dig(:user, :email).to_s.downcase.strip
    password = params.dig(:user, :password)

    user = User.find_by(email: email)

    if user && user.valid_password?(password) && user.admin?
      sign_in(:user, user)
      redirect_to rails_admin_path and return
    end

    flash[:alert] = "Invalid admin credentials"
    redirect_to adminurl_path
  end

  # Optional sign out for admin route
  def destroy
    sign_out(current_user) if current_user
    redirect_to root_path, notice: "Signed out"
  end
end
