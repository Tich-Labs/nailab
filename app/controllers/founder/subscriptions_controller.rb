class Founder::SubscriptionsController < Founder::BaseController
  include PricingPageConcern
  before_action :load_pricing_content, only: %i[show]

  def show
    @subscription = current_user.subscription
  end

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = current_user.build_subscription(subscription_params)
    if @subscription.save
      redirect_to founder_subscription_path, notice: 'Subscribed.'
    else
      render :new
    end
  end

  private

  def subscription_params
    params.require(:subscription).permit(:tier, :payment_method)
  end
end