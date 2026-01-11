class ProfileApprovalMailer < ApplicationMailer
  def approved
    @user = params[:user]
    @profile = params[:profile]
    @actor = params[:actor]
    mail(to: @user.email, subject: "Your Nailab profile has been approved")
  end

  def rejected
    @user = params[:user]
    @profile = params[:profile]
    @actor = params[:actor]
    @reason = params[:reason]
    mail(to: @user.email, subject: "Your Nailab profile update was declined")
  end
end
