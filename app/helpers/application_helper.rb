module ApplicationHelper
  # Renders FAQ answers allowing safe, limited hyperlinks using Markdown-style syntax:
  #   "Visit our [Mentors page](/mentors) to learn more."
  #
  # Output is sanitized and supports only <a> and <br> tags.
  def faq_answer_html(text)
    raw_text = text.to_s

    # Escape everything first so user input can't inject HTML.
    escaped = ERB::Util.html_escape(raw_text)

    # Convert markdown-style links: [label](url)
    linked = escaped.gsub(/\[([^\]]+)\]\(([^\)]+)\)/) do
      label = Regexp.last_match(1)
      url = Regexp.last_match(2)
      %(<a href="#{ERB::Util.html_escape(url)}" class="text-purple-600 font-bold">#{ERB::Util.html_escape(label)}</a>)
    end

    # Preserve line breaks
    html = linked.gsub(/\r?\n/, "<br>\n")

    sanitize(html, tags: %w[a br], attributes: %w[href class])
  end
end
