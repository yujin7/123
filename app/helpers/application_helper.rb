module ApplicationHelper
  def validation_errors(message)
    if message.class.to_s == "Array"
      message = message.join(", ")
    end
    return !message.to_s.blank? ? message.to_s: ""
  end


  def age(date_of_birth)
    unless date_of_birth.nil?
      years = Date.today.year - date_of_birth.year
      if Date.today.month < date_of_birth.month
        years = years + 1
      end
      if (Date.today.month == date_of_birth.month and Date.today.day < date_of_birth.day)
        years = years - 1
      end
      return years
    end
    nil
  end
  def get_guest_custom_field_input(field_name, field_type, value="", html_options='')
    if field_type == 'integer' or field_type == 'string' or field_type == 'float'
      text_field_tag "guest_custom_field[#{field_name}]", value
      #      input_field = "<input type='text' name='guest_custom_field[#{field_name}]' id='guest_custom_field_#{field_name}' #{html_options}>"
    elsif field_type == 'text'
      #      input_field = "<textarea name='guest_custom_field[#{field_name}]' 'guest_custom_field_#{field_name}' #{html_options}></textarea>"
      text_area_tag "guest_custom_field[#{field_name}]", value, :rows => "3", :cols => "25"
    elsif field_type == 'boolean'
      #      check_box_tag "guest_custom_field[#{field_name}]", "1", value
      select_tag "guest_custom_field[#{field_name}]", options_for_select([["Yes", 1], ["No", 0]], (value ? 1 : 0))
    end
    #    return input_field
  end
end
