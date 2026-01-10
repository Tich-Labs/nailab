module Admin
  class AboutsController < RailsAdmin::MainController
    def edit
      @sections = [
        { key: "why_nailab_exists", title: "Why Nailab Exists", path: admin_about_section_edit_path(section: "why_nailab_exists") },
        { key: "our_impact", title: "Our Impact", path: admin_about_section_edit_path(section: "our_impact") },
        { key: "vision_mission", title: "Vision & Mission", path: admin_about_section_edit_path(section: "vision_mission") },
        { key: "what_drives_us", title: "What Drives Us", path: admin_about_section_edit_path(section: "what_drives_us") }
      ]
    end

    def edit_section
      @section_key = params[:section]
      @section_title = section_title_for(@section_key)
      @about = AboutPage.first_or_create!(title: "About")
      stored = parse_about_content_json(@about)
      raw_section = stored[@section_key]

      if raw_section.is_a?(Hash)
        @section_content = raw_section.with_indifferent_access
      else
        html = raw_section.to_s
        heading_match = html.match(/<h[1-6][^>]*>(.*?)<\/h[1-6]>/m)
        if heading_match
          title = heading_match[1].to_s.strip
          body_html = html.sub(heading_match[0], "")
        else
          title = nil
          body_html = html
        end
        body_text = body_html.gsub(/<\s*\/p\s*>/i, "\n\n").gsub(/<br\s*\/?\s*>/i, "\n")
        body_text = ActionController::Base.helpers.strip_tags(body_text).strip
        @section_content = { "title" => title, "paragraph_one" => body_text }.with_indifferent_access
      end

      if @section_key == "what_drives_us"
        @section_content["title"] ||= "What Drives Us"
        @section_content["cards"] ||= default_what_drives_us_cards
        render "admin/abouts/what_drives_us/edit" and return
      end

      if @section_key == "our_impact"
        @section_content["title"] ||= "Our Impact"
        @section_content["description"] ||= "We partner with founders, mentors and partners to support startups across Africa."
        @section_content["stats"] ||= default_our_impact_stats
      end

      if @section_key == "our_mission"
        @section_content["title"] ||= "Our Mission"
        @section_content["description"] ||= default_mission_text
      elsif @section_key == "our_vision"
        @section_content["title"] ||= "Our Vision"
        @section_content["description"] ||= default_vision_text
      elsif @section_key == "vision_mission"
        @mission_content = stored["our_mission"] || { "title" => "Our Mission", "description" => default_mission_text }
        @vision_content = stored["our_vision"] || { "title" => "Our Vision", "description" => default_vision_text }
      end

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
    end

    def update_section
      @section_key = params[:section]
      @about = AboutPage.first_or_create!(title: "About")
      stored = parse_about_content_json(@about)

      Rails.logger.info("[DEBUG] update_section called for section: #{@section_key}; params keys: #{params.keys.inspect}")

      if @section_key == "vision_mission"
        begin
          mission_params = params.fetch(:section_payload).fetch(:mission).permit(:title, :description)
          vision_params = params.fetch(:section_payload).fetch(:vision).permit(:title, :description)
        rescue KeyError, ActionController::ParameterMissing => e
          Rails.logger.info("[DEBUG] Missing mission/vision payload: #{e.message}; params: #{params.inspect}")
          redirect_to admin_about_section_edit_path(@section_key), alert: "No data received from the form. Please try again.", status: :see_other and return
        end

        stored["our_mission"] = { "title" => mission_params[:title].to_s.strip, "description" => mission_params[:description].to_s.strip }
        stored["our_vision"] = { "title" => vision_params[:title].to_s.strip, "description" => vision_params[:description].to_s.strip }
        @about.update!(content: stored.to_json)
        redirect_to admin_about_section_edit_path(@section_key), notice: "Saved Vision & Mission", status: :see_other and return
      end

      begin
        section_params = params.require(:section_payload).permit(:title, :description, :paragraph_two, :paragraph_three, :image, :image_url, stats: [ :value, :label ], cards: [ :title, :description ])
      rescue ActionController::ParameterMissing => e
        Rails.logger.info("[DEBUG] Missing section_payload for section=#{@section_key}; full params: #{params.inspect}")
        redirect_to admin_about_section_edit_path(@section_key), alert: "No data received from the form. Please try again.", status: :see_other and return
      end

      payload = { "title" => section_params[:title].to_s.strip }

      if @section_key == "what_drives_us"
        cards = section_params[:cards] || []
        cards = cards.to_unsafe_h.values if cards.is_a?(ActionController::Parameters)
        cards = cards.values if cards.is_a?(Hash)
        payload["cards"] = cards.map { |c| { "title" => c["title"].to_s.strip, "description" => c["description"].to_s.strip } }
      else
        if @section_key == "why_nailab_exists"
          desc = section_params[:description].to_s.strip
          parts = desc.split(/\r?\n\r?\n+/).map(&:strip).reject(&:blank?)
          payload["paragraph_one"] = parts[0] || ""
          payload["paragraph_two"] = parts[1] || ""
          payload["paragraph_three"] = parts[2] || ""
        else
          payload["description"] = section_params[:description].to_s.strip
        end
      end

      if @section_key == "our_impact"
        stats = section_params[:stats] || []
        stats = stats.to_unsafe_h.values if stats.is_a?(ActionController::Parameters)
        stats = stats.values if stats.is_a?(Hash)
        normalized_stats = stats.map { |s| { "value" => s["value"].to_s.strip, "label" => s["label"].to_s.strip } }
        normalized_stats = normalized_stats.reject { |s| s["value"].blank? && s["label"].blank? }
        payload["stats"] = normalized_stats
        Rails.logger.info("[DEBUG] our_impact - stats_count=#{normalized_stats.length} payload: #{payload.inspect}")
      elsif @section_key == "our_mission" || @section_key == "our_vision"
        payload["title"] = section_params[:title].to_s.strip
        payload["description"] = section_params[:description].to_s.strip
      end

      if @section_key == "why_nailab_exists"
        begin
          if section_params[:image].present? && @about.respond_to?(:why_nailab_image)
            @about.why_nailab_image.attach(section_params[:image])
            stored.delete("#{@section_key}_image_url")
          elsif section_params[:image_url].present?
            stored["#{@section_key}_image_url"] = section_params[:image_url].to_s.strip
          end
        rescue => e
          Rails.logger.info("[DEBUG] why_nailab_exists image update failed: #{e.class}: #{e.message}")
        end
      end

      stored[@section_key] = payload
      @about.update!(content: stored.to_json)
      redirect_to admin_about_section_edit_path(@section_key), notice: "Saved #{section_title_for(@section_key)}", status: :see_other
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

    def default_our_impact_stats
      [
        { "value" => "10+", "label" => "Years of Impact" },
        { "value" => "54", "label" => "African Countries" },
        { "value" => "30+", "label" => "Innovation Programs" },
        { "value" => "$100M", "label" => "Funding Facilitated" },
        { "value" => "1000", "label" => "Startups Supported" },
        { "value" => "50+", "label" => "Partners" }
      ]
    end

    def default_what_drives_us_cards
      [
        { "id" => "entrepreneur-first", "title" => "Entrepreneur-First", "description" => "We prioritize the needs and growth of African entrepreneurs by offering support that is tailored, relevant, and results-driven." },
        { "id" => "innovation-for-impact", "title" => "Innovation for Impact", "description" => "We champion bold thinking and creative solutions that address real-world challenges and deliver lasting, meaningful change across communities and sectors." },
        { "id" => "inclusion", "title" => "Inclusion", "description" => "We strive to ensure that opportunities are accessible to all, ensuring that innovators of all backgrounds, especially youth and women, have equal access to resources and support they need." },
        { "id" => "collaboration", "title" => "Collaboration", "description" => "We believe in the power of partnerships and collective action to drive greater impact and scale solutions across Africa." },
        { "id" => "integrity", "title" => "Integrity", "description" => "We operate with transparency, accountability, and a commitment to ethical practices in all that we do." },
        { "id" => "continuous-learning", "title" => "Continuous Learning", "description" => "We foster a culture of curiosity, experimentation, and growth, always seeking to learn and improve." }
      ]
    end

    def default_mission_text
      "To be Africa's leading launchpad, empowering bold innovators with the knowledge, mentorship, and community to turn their ideas into scalable, tech-driven solutions that drive economic growth and address the continent's most pressing challenges."
    end

    def default_vision_text
      "To build an inclusive network that supports African founders through a collaborative platform where mentors, investors, and founders work together to scale innovative, tech-driven startups."
    end
  end
end
