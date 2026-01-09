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
        @section_content["cards"] ||= [
          { "title" => "Entrepreneur-First", "description" => "We prioritize the needs and growth of African entrepreneurs by offering support that is tailored, relevant, and results-driven." },
          { "title" => "Innovation for Impact", "description" => "We champion bold thinking and creative solutions that address real-world challenges and deliver lasting, meaningful change across communities and sectors." },
          { "title" => "Inclusion", "description" => "We strive to ensure that opportunities are accessible to all, ensuring that innovators of all backgrounds, especially youth and women, have equal access to resources and support they need." },
          { "title" => "Collaboration", "description" => "We believe in the power of partnerships and collective action to drive greater impact and scale solutions across Africa." },
          { "title" => "Integrity", "description" => "We operate with transparency, accountability, and a commitment to ethical practices in all that we do." },
          { "title" => "Continuous Learning", "description" => "We foster a culture of curiosity, experimentation, and growth, always seeking to learn and improve." }
        ]
        render "admin/abouts/what_drives_us/edit" and return
      end

      # Ensure our_impact always has title, description, and stats
      if @section_key == "our_impact"
        @section_content["title"] ||= "Our Impact"
        @section_content["description"] ||= "We partner with founders, mentors and partners to support startups across Africa."
        @section_content["stats"] ||= [
          { value: "10+", label: "Years of Impact" },
          { value: "54", label: "African Countries" },
          { value: "30+", label: "Innovation Programs" },
          { value: "$100M", label: "Funding Facilitated" },
          { value: "1000", label: "Startups Supported" },
          { value: "50+", label: "Partners" }
        ]
      end

      # Ensure our_mission and our_vision always have title and description
      if @section_key == "our_mission"
        @section_content["title"] ||= "Our Mission"
        @section_content["description"] ||= "To be Africa's leading launchpad, empowering bold innovators with the knowledge, mentorship, and community to turn their ideas into scalable, tech-driven solutions that drive economic growth and address the continent's most pressing challenges."
      elsif @section_key == "our_vision"
        Rails.logger.info("[DEBUG] update_section called for section: #{@section_key}")
        Rails.logger.info("[DEBUG] Raw params: #{params.inspect}")
        Rails.logger.info("[DEBUG] Permitted section_params: #{section_params.inspect}")
        @section_content["title"] ||= "Our Vision"
        @section_content["description"] ||= "To build an inclusive network that supports African founders through a collaborative platform where mentors, investors, and founders work together to scale innovative, tech-driven startups."
      elsif @section_key == "vision_mission"
        @mission_content = stored["our_mission"] || { "title" => "Our Mission", "description" => "To be Africa's leading launchpad, empowering bold innovators with the knowledge, mentorship, and community to turn their ideas into scalable, tech-driven solutions that drive economic growth and address the continent's most pressing challenges." }
        @vision_content = stored["our_vision"] || { "title" => "Our Vision", "description" => "To build an inclusive network that supports African founders through a collaborative platform where mentors, investors, and founders work together to scale innovative, tech-driven startups." }
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

      # Handle different parameter structures for different sections
      if @section_key == "vision_mission"
        # Vision & Mission has special structure
        mission_params = params[:section_payload][:mission].permit(:title, :description)
        vision_params = params[:section_payload][:vision].permit(:title, :description)
        stored["our_mission"] = { "title" => mission_params[:title].to_s.strip, "description" => mission_params[:description].to_s.strip }
        stored["our_vision"] = { "title" => vision_params[:title].to_s.strip, "description" => vision_params[:description].to_s.strip }
        @about.update!(content: stored.to_json)
        redirect_to admin_about_section_edit_path(@section_key), notice: "Saved Vision & Mission"
        nil
      else
        # Standard section structure
        section_params = params.require(:section_payload).permit(:title, :description, :paragraph_two, :paragraph_three, stats: [ :value, :label ], cards: [ :title, :description ])

        payload = {
          "title" => section_params[:title].to_s.strip
        }

        if @section_key == "what_drives_us"
          cards = section_params[:cards] || []
          if cards.is_a?(ActionController::Parameters)
            cards = cards.to_unsafe_h.values
          elsif cards.is_a?(Hash)
            cards = cards.values
          end
          payload["cards"] = cards.map { |c| { "title" => c["title"].to_s.strip, "description" => c["description"].to_s.strip } }
        else
          # For the 'why_nailab_exists' section the public template expects
          # the first paragraph under the key `paragraph_one`. Map the
          # editor's generic `description` field to `paragraph_one` so
          # edits appear on the public /about page.
          if @section_key == "why_nailab_exists"
            # Accept a single textarea and split into up to three paragraphs.
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
          # Parse stats as array of hashes, handle ActionController::Parameters, Hash, or Array
          stats = section_params[:stats] || []
          if stats.is_a?(ActionController::Parameters)
            stats = stats.to_unsafe_h.values
          elsif stats.is_a?(Hash)
            stats = stats.values
          end
          payload["stats"] = stats.map { |s| { value: s["value"].to_s.strip, label: s["label"].to_s.strip } }
        elsif @section_key == "our_mission" || @section_key == "our_vision"
          payload["title"] = section_params[:title].to_s.strip
          payload["description"] = section_params[:description].to_s.strip
        end

        stored[@section_key] = payload
        @about.update!(content: stored.to_json)
        redirect_to admin_about_section_edit_path(@section_key), notice: "Saved #{section_title_for(@section_key)}"
      end
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
