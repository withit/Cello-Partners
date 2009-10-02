class Notifier < ActionMailer::Base
  def quote quote
    recipients quote.email.blank? ? (UserSession.find && UserSession.find.user).email : @email
    from       "partners@cello.com.au"
    subject    "Cello quote for #{quote.grade_name} #{quote.calliper} um #{quote.gsm} gsm"
    body       :quote => quote
  end

end
