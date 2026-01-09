module Admin
  class ContactPageController < RailsAdmin::MainController
    helper ::ApplicationHelper

    # GET /admin/contact_page/:id/edit or /admin/contact_page/:slug/edit
    def edit
      @contact_page = if params[:id].present?
        ::ContactPage.find_by(id: params[:id])
      elsif params[:slug].present?
        begin
          if ActiveRecord::Base.connection.column_exists?(:contact_pages, :slug)
            ::ContactPage.find_by(slug: params[:slug])
          else
            nil
          end
        rescue StandardError
          nil
        end
      end

      @contact_page ||= ::ContactPage.first_or_create!(title: "Contact Us")

      parsed = parse_contact_structured_content(@contact_page.content)
      @contact_content = default_contact_content.deep_merge(parsed).with_indifferent_access

      @faqs = (@contact_content[:faqs].is_a?(Array) ? @contact_content[:faqs].map { |f| f.is_a?(Hash) ? f.with_indifferent_access : {} } : [])
      @faqs = @faqs.first(8)
      @faqs << {} while @faqs.size < 8
    end

    # PATCH /admin/contact_page/:id or /admin/contact_page/:slug
    def update
      @contact_page = if params[:id].present?
        ::ContactPage.find_by(id: params[:id])
      elsif params[:slug].present?
        begin
          if ActiveRecord::Base.connection.column_exists?(:contact_pages, :slug)
            ::ContactPage.find_by(slug: params[:slug])
          else
            nil
          end
        rescue StandardError
          nil
        end
      end
      @contact_page ||= ::ContactPage.first_or_create!(title: "Contact Us")

      if params[:contact_page].present?
        begin
          @contact_page.update!(params.require(:contact_page).permit(:title, :content))
        rescue => e
          Rails.logger.error("[Admin::ContactPage] contact_page update failed: #{e.message}")
        end
      end

      if params[:contact_content].present?
        content = default_contact_content.deep_merge(parse_contact_structured_content(@contact_page.content)).with_indifferent_access
        pc = params.require(:contact_content).permit!.to_h.with_indifferent_access

        # Merge simple string fields preserving existing values when the submitted value is blank
        %w[title intro email phone].each do |k|
          if pc.key?(k) || pc.key?(k.to_sym)
            val = pc[k] || pc[k.to_sym]
            val = val.to_s.strip
            content[k] = val.present? ? val : (content[k] || "")
          end
        end

        # Contact form editing is intentionally not supported via admin.
        content.delete(:form)
        content.delete("form")

        # FAQs - exactly 8. Preserve existing question/answer when blanks submitted.
        if pc.key?(:faqs)
          incoming = normalize_faqs_param(pc[:faqs])
          existing = content[:faqs].is_a?(Array) ? content[:faqs] : []

          faqs = []
          8.times do |i|
            fhash = (incoming[i] || {}).to_h
            ex = (existing[i] || {}).to_h
            q = fhash["question"].to_s.strip
            a = fhash["answer"].to_s.strip
            faqs << {
              question: (q.present? ? q : (ex["question"] || ex[:question] || "")),
              answer: (a.present? ? a : (ex["answer"] || ex[:answer] || ""))
            }
          end
          content[:faqs] = faqs
        end

        @contact_page.update!(content: content.to_json)
      end

      safe_slug = (@contact_page.respond_to?(:slug) ? @contact_page.slug : nil) rescue nil
      if safe_slug.present?
        redirect_to edit_admin_contact_page_slug_path(safe_slug), notice: "Contact page saved"
      else
        redirect_to edit_admin_contact_page_path(@contact_page), notice: "Contact page saved"
      end
    end

    private

    def parse_contact_structured_content(content)
      return {} unless content.present?
      parsed = JSON.parse(content) rescue {}
      parsed.is_a?(Hash) ? parsed.with_indifferent_access : {}
    end

    def default_contact_content
      {
        title: "Contact Us",
        intro: "Have a question, partnership inquiry, or want to get in touch? We'd love to hear from you.",
        email: "ceo@nailab.co.ke",
        phone: "+254 790 492 467",
        faqs: default_faqs
      }.with_indifferent_access
    end

    def default_faqs
      [
        {
          question: "1. What kind of startups does Nailab support?",
          answer: "Nailab supports early-stage and growth-stage startups leveraging innovation to tackle Africa’s most pressing social challenges across key sectors including fintech, agritech, healthtech, edtech, SaaS, cleantech, creative & mediatech, e-commerce & retailtech, mobility & logisticstech, and social impact. We partner with passionate founders with a clear vision and deep understanding of the challenges they are addressing."
        },
        {
          question: "2. How do I apply for Nailab’s programs?",
          answer: "Interested in joining a Nailab program? We regularly announce application windows on our official website and social media platforms. You can find detailed information and application links for all our current opportunities on our Programs page."
        },
        {
          question: "3. What does a typical incubation and/or accelerator program involve?",
          answer: "Our programs typically run for 3–6 months, depending on the specific focus and structure. They are designed to equip entrepreneurs with the tools, knowledge, and networks they need to build and scale sustainable businesses. Key components include mentorship, business development training, pitch coaching, access to investors, and seed funding where applicable."
        },
        {
          question: "4. What stage should my startup be at to apply for Nailab Programs?",
          answer: "While some programs are tailored for early-stage entrepreneurs, others suit startups with a developed product and initial traction. Review eligibility in each program call for details."
        },
        {
          question: "5. Does Nailab provide funding to startups?",
          answer: "Yes. Some programs provide seed funding or connect startups to investors through demo days and pitch sessions."
        },
        {
          question: "6. What are the benefits of joining the Nailab startup network?",
          answer: "Access a thriving community of founders, expert mentors, and ecosystem partners, plus tools, templates, and curated resources to help you build and grow."
        },
        {
          question: "7. How can I become a Nailab mentor?",
          answer: "We’re always looking for experienced mentors. Visit our Mentors page to learn more and apply."
        },
        {
          question: "8. How can I partner with Nailab?",
          answer: "We collaborate with agencies, corporates, governments, and academia to co-create programs and support startups. Reach out via our Expertise page."
        }
      ]
    end

    def normalize_faqs_param(raw)
      case raw
      when Array
        raw.map { |f| normalize_faq_hash(f) }
      when Hash, ActionController::Parameters
        h = raw.to_h
        indexed = h
          .select { |k, _| k.to_s.match?(/\A\d+\z/) }
          .sort_by { |k, _| k.to_i }
          .map { |_, v| normalize_faq_hash(v) }

        new_entry = h["new"] || h[:new]
        new_hash = normalize_faq_hash(new_entry)
        if new_hash["question"].to_s.strip.present? || new_hash["answer"].to_s.strip.present?
          indexed << new_hash
        end

        indexed
      else
        []
      end
    end

    def normalize_faq_hash(raw)
      return { "question" => "", "answer" => "" } unless raw.present?
      h = raw.respond_to?(:to_unsafe_h) ? raw.to_unsafe_h : raw.to_h
      {
        "question" => (h["question"] || h[:question] || "").to_s,
        "answer" => (h["answer"] || h[:answer] || "").to_s
      }
    rescue StandardError
      { "question" => "", "answer" => "" }
    end
  end
end
