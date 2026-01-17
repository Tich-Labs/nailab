require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  include Devise::Test::ControllerHelpers
  before do
    Program.delete_all
    Category.delete_all
  end

  describe "GET #programs" do
    it "returns programs matching Startup Incubation & Acceleration" do
      p1 = Program.create!(title: "Incubation Program", slug: "incubation", program_type: "Startup Incubation & Acceleration", active: true, start_date: Date.today)
      p2 = Program.create!(title: "Other Program", slug: "other", program_type: "Research & Development", active: true, start_date: Date.today)

      get :programs, params: { category: "Startup Incubation & Acceleration" }

      expect(response).to have_http_status(:ok)
      programs = controller.instance_variable_get(:@programs)
      expect(programs.map(&:id)).to include(p1.id)
      expect(programs.map(&:id)).not_to include(p2.id)
    end

    it "returns programs associated with a matching category name or slug" do
      cat = Category.create!(name: "Masterclasses & Mentorship", slug: "masterclasses_and_mentorship")
      p = Program.create!(title: "Masterclass Program", slug: "masterclass", program_type: "Masterclasses & Mentorship", active: true, start_date: Date.today)
      p.categories << cat

      get :programs, params: { category: "Masterclasses & Mentorship" }

      expect(response).to have_http_status(:ok)
      programs = controller.instance_variable_get(:@programs)
      expect(programs.map(&:id)).to include(p.id)
    end
  end
end
