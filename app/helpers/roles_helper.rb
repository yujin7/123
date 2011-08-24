module RolesHelper
  def validation_errors(message)
    if message.class.to_s == "Array"
      message = message.join(", ")
    end
    return !message.to_s.blank? ? message.to_s: ""
  end
end
