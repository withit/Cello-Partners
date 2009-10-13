# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def alt
    {:class => cycle('odd','even')}
  end
end
