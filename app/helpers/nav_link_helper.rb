module NavLinkHelper
  def nav_link(name, path, icon: nil, method: nil)
    active = current_page?(path)
    classes = [
      'flex items-center gap-3 px-4 py-2 rounded-lg transition-colors',
      active ? 'bg-[#00BCD4] text-[#4A148C] font-semibold' : 'hover:bg-[#4A148C]/20 text-white'
    ].join(' ')
    icon_tag = icon ? content_tag(:i, '', class: "#{icon} w-5 h-5") : ''
    link_to path, method: method, class: classes, data: { turbo_frame: '_top' } do
      icon_tag.html_safe + content_tag(:span, name, class: 'ml-1')
    end
  end
end
