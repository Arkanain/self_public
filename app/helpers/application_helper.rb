module ApplicationHelper
  def action_button(name, icon_class)
    content_tag(:i, '', class: "fa #{icon_class}") + content_tag(:span, name, class: 'button_text')
  end
end