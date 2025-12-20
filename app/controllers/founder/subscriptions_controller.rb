class Founder::SubscriptionsController < Founder::BaseController
  include PricingPageConcern
  before_action :load_pricing_content, only: %i[show new]

  def show
    @subscription = current_user.subscription
  end

  def new
    @subscription = Subscription.new
  end

  def create
    if current_user.subscription
      # Update existing subscription
      if current_user.subscription.update(subscription_params)
        redirect_to founder_subscription_path, notice: "Subscription updated successfully."
      else
        @subscription = current_user.subscription
        render :new
      end
    else
      # Create new subscription
      @subscription = current_user.build_subscription(subscription_params)
      if @subscription.save
        redirect_to founder_subscription_path, notice: "Subscribed successfully."
      else
        render :new
      end
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:tier, :payment_method)
  end
end
