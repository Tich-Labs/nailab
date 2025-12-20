class MentorOnboardingController < ApplicationController
  skip_before_action :authenticate_user!
  # before_action :authenticate_user! # Removed to allow onboarding without login
  # before_action :ensure_mentor_role # Removed to allow onboarding without login
  # before_action :load_profile # Will refactor for session-based or new model onboarding

  STEPS = %w[basic_details work_experience mentorship_focus mentorship_style availability review]

  def show
    @profile = UserProfile.new
    @step = params[:step] || STEPS.first
    unless STEPS.include?(@step)
      redirect_to mentor_onboarding_path(step: STEPS.first)
      return
    end

    # Handle "Other" options for mentorship_focus step
    if @step == "mentorship_focus"
      prepare_mentorship_focus_form_data
    end

    # Save current step for resume later
    @profile.update(onboarding_step: @step) unless @profile.onboarding_step == @step

    @progress = (STEPS.index(@step) + 1).to_f / STEPS.length * 100
  end
end

  def update
    @step = params[:step]
    unless STEPS.include?(@step)
      redirect_to mentor_onboarding_path(step: STEPS.first)
      return
    end

    if params[:save_and_exit].present?
      # Handle save and exit
      mentorship_params = mentor_params_for_step(@step)
      if @step == "mentorship_focus"
        mentorship_params = process_mentorship_focus_params(mentorship_params)
      end
      if @profile.update(mentorship_params)
        @profile.update(onboarding_step: @step)
        redirect_to mentor_root_path, notice: "Your progress has been saved. You can continue onboarding later."
      else
        @progress = (STEPS.index(@step) + 1).to_f / STEPS.length * 100
        render :show
      end
    elsif @step == "mentorship_focus"
      mentorship_params = mentor_params_for_step(@step)
      mentorship_params = process_mentorship_focus_params(mentorship_params)
      if @profile.update(mentorship_params)
        next_step = next_step(@step)
        if next_step
          redirect_to mentor_onboarding_path(step: next_step)
        else
          complete_onboarding
        end
      else
        @progress = (STEPS.index(@step) + 1).to_f / STEPS.length * 100
        render :show
      end
    elsif @profile.update(mentor_params_for_step(@step))
      next_step = next_step(@step)
      if next_step
        redirect_to mentor_onboarding_path(step: next_step)
      else
        complete_onboarding
      end
    else
      @progress = (STEPS.index(@step) + 1).to_f / STEPS.length * 100
      render :show
    end
  end

  private

  def ensure_mentor_role
    unless current_user.user_profile&.role == "mentor"
      redirect_to root_path, alert: "Access denied"
    end
  end

  def load_profile
    @profile = current_user.user_profile || current_user.build_user_profile
  end

  def mentor_params_for_step(step)
    case step
    when "basic_details"
      params.require(:user_profile).permit(:full_name, :bio, :title)
    when "work_experience"
      params.require(:user_profile).permit(:organization, :years_experience, :advisory_experience, :advisory_description)
    when "mentorship_focus"
      params.require(:user_profile).permit(sectors: [], expertise: [], stage_preference: [], other_sector: [], other_expertise: [])
    when "mentorship_style"
      params.require(:user_profile).permit(:mentorship_approach, :motivation)
    when "availability"
      params.require(:user_profile).permit(:availability_hours_month, :preferred_mentorship_mode, :rate_per_hour, :pro_bono, :linkedin_url, :professional_website, :currency)
    else
      {}
    end
  end

  def next_step(current_step)
    current_index = STEPS.index(current_step)
    STEPS[current_index + 1] if current_index && current_index < STEPS.length - 1
  end

  def prepare_mentorship_focus_form_data
    # Prepare sectors for form display
    if @profile.sectors.present?
      predefined_sectors = [ "Agritech", "Healthtech", "Fintech", "Edutech", "Mobility & Logistics tech", "E-commerce & Retailtech", "SaaS", "Creative & Mediatech", "Cleantech", "AI & ML", "Robotics", "Mobiletech", "Other" ]
      custom_sectors = (@profile.sectors - predefined_sectors)
      if custom_sectors.any?
        @profile.sectors = (@profile.sectors - custom_sectors) + [ "Other" ]
        @other_sector = custom_sectors.first
      end
    end

    # Prepare expertise for form display
    if @profile.expertise.present?
      predefined_expertise = [ "Business model refinement", "PMF", "Access to customers/markets", "GTM planning", "Product development", "Pitching/fundraising", "Marketing/branding", "Team building/HR", "Budgeting/finance", "Market expansion", "Legal/regulatory", "Leadership growth", "Partnerships", "Sales & acquisition", "Other" ]
      custom_expertise = (@profile.expertise - predefined_expertise)
      if custom_expertise.any?
        @profile.expertise = (@profile.expertise - custom_expertise) + [ "Other" ]
        @other_expertise = custom_expertise.first
      end
    end
  end
