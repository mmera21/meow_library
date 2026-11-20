module ApplicationHelper
  def nav_categories
    @nav_categories ||= Category.order(:name)
  end
end