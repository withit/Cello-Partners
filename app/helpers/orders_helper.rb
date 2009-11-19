module OrdersHelper
  def color_for status
    case status
    when :available then '#96D56C'
    when :not_available then '#EE1C25'
    when :limited then "#FCA61B"
    end
  end
end
