class HomeController < ApplicationController
  def index
    @sections = HomepageSection.visible
  end
end
