# Service class for handling About page content operations
class AboutPageService
  class << self
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

    def build_section_payload(section_key, section_params)
      case section_key
      when "what_drives_us"
        build_what_drives_us_payload(section_params)
      when "why_nailab_exists"
        build_why_nailab_exists_payload(section_params)
      else
        { "description" => section_params[:description].to_s.strip }
      end
    end

    def handle_special_section_updates(section_key, section_params, payload)
      case section_key
      when "our_impact"
        handle_our_impact_updates(section_params, payload)
      when "our_mission", "our_vision"
        payload["title"] = section_params[:title].to_s.strip
        payload["description"] = section_params[:description].to_s.strip
      end
    end





    private

    def build_what_drives_us_payload(section_params)
      cards = section_params[:cards] || []
      cards = cards.to_unsafe_h.values if cards.is_a?(ActionController::Parameters)
      cards = cards.values if cards.is_a?(Hash)
      { "cards" => cards.map { |card| { "title" => card["title"].to_s.strip, "description" => card["description"].to_s.strip } } }
    end

    def build_why_nailab_exists_payload(section_params)
      description = section_params[:description].to_s.strip
      parts = description.split(/\r?\n\r?\n+/).map(&:strip).reject(&:blank?)
      {
        "paragraph_one" => parts[0] || "",
        "paragraph_two" => parts[1] || "",
        "paragraph_three" => parts[2] || ""
      }
    end

    def handle_our_impact_updates(section_params, payload)
      stats = section_params[:stats] || []
      stats = stats.to_unsafe_h.values if stats.is_a?(ActionController::Parameters)
      stats = stats.values if stats.is_a?(Hash)
      normalized_stats = stats.map { |stat| { "value" => stat["value"].to_s.strip, "label" => stat["label"].to_s.strip } }
      normalized_stats = normalized_stats.reject { |stat| stat["value"].blank? && stat["label"].blank? }
      payload["stats"] = normalized_stats
    end
  end
end
