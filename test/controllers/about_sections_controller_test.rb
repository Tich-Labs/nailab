require "test_helper"

class AboutSectionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @about_section = about_sections(:one)
  end

  test "should get index" do
    get about_sections_url
    assert_response :success
  end

  test "should get new" do
    get new_about_section_url
    assert_response :success
  end

  test "should create about_section" do
    assert_difference("AboutSection.count") do
      post about_sections_url, params: { about_section: { content: @about_section.content, section_type: @about_section.section_type, title: @about_section.title } }
    end

    assert_redirected_to about_section_url(AboutSection.last)
  end

  test "should show about_section" do
    get about_section_url(@about_section)
    assert_response :success
  end

  test "should get edit" do
    get edit_about_section_url(@about_section)
    assert_response :success
  end

  test "should update about_section" do
    patch about_section_url(@about_section), params: { about_section: { content: @about_section.content, section_type: @about_section.section_type, title: @about_section.title } }
    assert_redirected_to about_section_url(@about_section)
  end

  test "should destroy about_section" do
    assert_difference("AboutSection.count", -1) do
      delete about_section_url(@about_section)
    end

    assert_redirected_to about_sections_url
  end
end
