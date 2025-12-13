class ResourcesController < ApplicationController
  def index
    @category = params[:category] || "all"
    @blog_posts = BlogPost.all if @category == "all" || @category == "blog"
    @template_guides = TemplateGuide.all if @category == "all" || @category == "guides"
    @opportunities = Opportunity.all if @category == "all" || @category == "opportunities"
    @events = Event.all if @category == "all" || @category == "events"
  end
end
