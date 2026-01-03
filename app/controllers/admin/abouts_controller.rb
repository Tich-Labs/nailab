module Admin
  class AboutsController < RailsAdmin::MainController
    # Render a simple Sections dashboard for the About page (anchors to subsections)
    def edit
      @sections = [
        { key: "why_nailab_exists", title: "Why Nailab Exists", path: admin_about_section_edit_path(section: "why_nailab_exists") },
        { key: "our_impact", title: "Our Impact", path: admin_about_section_edit_path(section: "our_impact") },
        { key: "vision_mission", title: "Vision & Mission", path: admin_about_section_edit_path(section: "vision_mission") },
        { key: "what_drives_us", title: "What Drives Us", path: admin_about_section_edit_path(section: "what_drives_us") }
      ]
    end

    # GET /admin/about/sections/:section/edit
    def edit_section
      @section_key = params[:section]
      @section_title = section_title_for(@section_key)

      @about = AboutPage.first_or_create!(title: "About")
      stored = parse_about_content_json(@about)
      raw_section = stored[@section_key]
      if raw_section.is_a?(Hash)
        @section_content = raw_section.with_indifferent_access
      else
        # Legacy: if stored as raw HTML/string, try to extract a heading as title and the rest as plain text paragraph(s)
        html = raw_section.to_s
        heading_match = html.match(/<h[1-6][^>]*>(.*?)<\/h[1-6]>/m)
        if heading_match
          title = heading_match[1].to_s.strip
          body_html = html.sub(heading_match[0], "")
        else
          title = nil
          body_html = html
        end
        # Convert basic paragraph tags to newlines and strip remaining tags for plain text editing
        body_text = body_html.gsub(/<\s*\/p\s*>/i, "\n\n").gsub(/<br\s*\/?\s*>/i, "\n")
        body_text = ActionController::Base.helpers.strip_tags(body_text).strip
        @section_content = { "title" => title, "paragraph_one" => body_text }.with_indifferent_access
      end

      # Determine image URL: prefer attached ActiveStorage for why_nailab_exists, otherwise stored image_url key
      @section_image_url = nil
      if @section_key == "why_nailab_exists" && @about.respond_to?(:why_nailab_image) && @about.why_nailab_image.attached?
        begin
          @section_image_url = url_for(@about.why_nailab_image)
        rescue => _e
          @section_image_url = stored["#{@section_key}_image_url"]
        end
      else
        @section_image_url = stored["#{@section_key}_image_url"]
      end

      # If there's no stored content at all, preload the editor with the default static copy
      if @section_key == "why_nailab_exists" && (@section_content["title"].blank? && @section_content["paragraph_one"].blank?)
        @section_content["title"] = "Why Nailab Exists"
        @section_content["paragraph_one"] = "Limited access to capital and knowledge are among the biggest challenges African founders face when launching their startups. In Africa, Nailab is changing that narrative by lowering the barriers to entry for tech founders looking to start and scale their businesses."
        @section_content["paragraph_two"] = "For over a decade, we have supported founders with the skills, mentorship, and funding they need to build scalable, impact-driven businesses that tackle Africa's most pressing challenges. Through strategic partnerships and tailored coaching programs, we create an enabling environment where startups can succeed — connecting them with investors, mentors, and key networks."
        @section_content["paragraph_three"] = "At Nailab, we believe in the power of African-led solutions to transform industries and uplift communities."
        @section_image_url = "https://images.pexels.com/photos/3184465/pexels-photo-3184465.jpeg?auto=compress&cs=tinysrgb&w=1200" if @section_image_url.blank?
      end
    end

    # PATCH /admin/about/sections/:section
    def update_section
      @section_key = params[:section]
      @about = AboutPage.first_or_create!(title: "About")
      stored = parse_about_content_json(@about)
      section_params = params.require(:section_payload).permit(:title, :subheading, :paragraph_one, :paragraph_two, :paragraph_three, :image_url, :image_file)

      payload = {
        "title" => section_params[:title].to_s.strip,
        "subheading" => section_params[:subheading].to_s.strip,
        "paragraph_one" => section_params[:paragraph_one].to_s.strip,
        "paragraph_two" => section_params[:paragraph_two].to_s.strip,
        "paragraph_three" => section_params[:paragraph_three].to_s.strip
      }
      stored[@section_key] = payload

      # Handle optional uploaded image file or image URL
      if section_params[:image_file].present?
        begin
          if @section_key == "why_nailab_exists" && @about.respond_to?(:why_nailab_image)
            @about.why_nailab_image.attach(section_params[:image_file])
            if @about.why_nailab_image.attached?
              stored["#{@section_key}_image_url"] = url_for(@about.why_nailab_image)
            end
          else
            stored["#{@section_key}_image_url"] = section_params[:image_url].to_s.strip if section_params[:image_url].present?
          end
        rescue => e
          Rails.logger.warn("About section image attach failed: #{e.message}")
        end
      elsif section_params[:image_url].present?
        stored["#{@section_key}_image_url"] = section_params[:image_url].to_s.strip
      end

      @about.update!(content: stored.to_json)
      redirect_to admin_about_section_edit_path(@section_key), notice: "Saved #{section_title_for(@section_key)}"
    end

    private

    def section_title_for(key)
      case key.to_s
      when "why_nailab_exists" then "Why Nailab Exists"
      when "our_impact" then "Our Impact"
      when "vision_mission" then "Vision & Mission"
      when "what_drives_us" then "What Drives Us"
      else key.to_s.humanize
      end
    end

    def parse_about_content_json(about)
      return {} unless about&.content.present?
      JSON.parse(about.content) rescue {}
    end
  end
end
