module ActiveAdminHelper
  def nav_link_classes(path)
    base = "block w-full text-left px-5 py-3 rounded-lg font-medium transition"
    if path == "#"
      "#{base} text-gray-400 cursor-not-allowed"
    else
      active = current_page?(path) ? "bg-[#00BCD4] text-[#4A148C]" : "hover:bg-white/10"
      "#{base} #{active}"
    end
  end

  def admin_resource_path(resource_name)
    return "#" if resource_name.blank?
    helper_name = "admin_#{resource_name.pluralize}_path"
    begin
      send(helper_name)
    rescue NameError
      "#"
    end
  end

  def flash_class(type)
    case type.to_sym
    when :notice then "bg-teal-100 text-teal-800"
    when :alert  then "bg-red-100 text-red-800"
    when :error  then "bg-red-100 text-red-800"
    else "bg-gray-100 text-gray-800"
    end
  end
end
