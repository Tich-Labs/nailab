module Founder::StartupUpdatesHelper
  def months_options
    Date::MONTHNAMES.compact.each_with_index.map { |name, i| [ name, i+1 ] }
  end
  def years_options
    ((Date.today.year - 3)..Date.today.year).to_a.reverse
  end
end
