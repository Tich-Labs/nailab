module Admin
  class ContactPageController < RailsAdmin::MainController
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

      @contact_content = parse_contact_structured_content(@contact_page.content)
      @faqs = (@contact_content[:faqs].is_a?(Array) ? @contact_content[:faqs].map { |f| f.is_a?(Hash) ? f.with_indifferent_access : {} } : [])
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
        content = parse_contact_structured_content(@contact_page.content).with_indifferent_access
        pc = params.require(:contact_content).permit!.to_h.with_indifferent_access

        # Merge simple string fields preserving existing values when the submitted value is blank
        %w[title intro email phone].each do |k|
          if pc.key?(k) || pc.key?(k.to_sym)
            val = pc[k] || pc[k.to_sym]
            val = val.to_s.strip
            content[k] = val.present? ? val : (content[k] || "")
          end
        end

        # Form placeholders
        content[:form] ||= {}
        if pc.key?(:form)
          pc_form = pc[:form] || {}
          %w[name_placeholder email_placeholder subject_placeholder message_placeholder submit_label].each do |fld|
            if pc_form.key?(fld) || pc_form.key?(fld.to_sym)
              v = (pc_form[fld] || pc_form[fld.to_sym]).to_s.strip
              content[:form][fld] = v.present? ? v : (content[:form][fld] || "")
            end
          end
        end

        # FAQs - replace if present; preserve question/answer when blanks submitted
        if pc.key?(:faqs)
          incoming = pc[:faqs] || []
          existing = content[:faqs] || []
          faqs = []
          incoming.each_with_index do |f, i|
            fhash = (f || {}).to_h
            ex = existing[i] || {}
            q = fhash["question"].to_s.strip
            a = fhash["answer"].to_s.strip
            faqs << { question: (q.present? ? q : (ex["question"] || ex[:question] || "")), answer: (a.present? ? a : (ex["answer"] || ex[:answer] || "")) }
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
  end
end
