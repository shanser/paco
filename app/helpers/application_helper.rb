# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def mode_admin?
    not @mode_admin.nil?
  end
end
