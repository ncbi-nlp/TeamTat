module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"

    if column == sort_column
      if sort_direction == "asc"
        title = "<span class='sort-active'>#{title} <i class='fa fa-sort-up'></i></span>"
      else
        title = "<span class='sort-active'>#{title} <i class='fa fa-sort-down'></i></span>"
      end
    else
      title = "<span class='sort-inactive'>#{title} <i class='fa fa-sort'></i></span>"
    end
    link_to title.html_safe, {:sort => column, :direction => direction}, {:class => css_class}
  end
end
