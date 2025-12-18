class Founder::BaseController < ApplicationController
  before_action :authenticate_user!
  layout "founder_dashboard"
end