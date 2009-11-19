module OrdersHelper
  def color_for status
    case status
    when :available then '#96D56C'
    when :not_available then '#AAAAAAA'
    when :limited then "#EE1C25"
    end
  end
end
