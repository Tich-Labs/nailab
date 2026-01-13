require 'rails_helper'


RSpec.describe StartupProfile, type: :model do
  let(:user) { User.create!(email: "test@example.com", password: "password") }
  let(:valid_attributes) do
    {
      startup_name: "Test Startup",
      description: "A test description",
      stage: "Early",
      target_market: "Non Profits",
      value_proposition: "Unique value",
      user: user
    }
  end

  it "does not require sector or funding_stage on step 'startup'" do
    profile = StartupProfile.new(valid_attributes)
    profile.onboarding_step = "startup"
    expect(profile).to be_valid
    expect(profile.errors[:sector]).to be_empty
    expect(profile.errors[:funding_stage]).to be_empty
  end

  it "does not require sector or funding_stage on step 'professional'" do
    profile = StartupProfile.new(valid_attributes)
    profile.onboarding_step = "professional"
    expect(profile).to be_valid
    expect(profile.errors[:sector]).to be_empty
    expect(profile.errors[:funding_stage]).to be_empty
  end

  it "requires sector and funding_stage on step 'confirm'" do
    profile = StartupProfile.new(valid_attributes)
    profile.onboarding_step = "confirm"
    expect(profile).not_to be_valid
    expect(profile.errors[:sector]).to include("can't be blank")
    expect(profile.errors[:funding_stage]).to include("can't be blank")
  end

  it "requires sector and funding_stage when onboarding_step is blank (normal edit)" do
    profile = StartupProfile.new(valid_attributes)
    profile.onboarding_step = nil
    expect(profile).not_to be_valid
    expect(profile.errors[:sector]).to include("can't be blank")
    expect(profile.errors[:funding_stage]).to include("can't be blank")
  end

  it "is valid on confirm step when all fields are present" do
    profile = StartupProfile.new(valid_attributes.merge(sector: "Tech", funding_stage: "Seed"))
    profile.onboarding_step = "confirm"
    expect(profile).to be_valid
  end
end
