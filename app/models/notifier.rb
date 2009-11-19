class Notifier < ActionMailer::Base
  def quote quote
    recipients quote.email.blank? ? (UserSession.find && UserSession.find.user).email : quote.email
    from       "partners@cello.com.au"
    cc         "sales@cello.com.au" if quote.is_a?(Order)
    subject    "#{quote.organisation_name} quote for #{quote.grade_name} #{quote.calliper} um #{quote.gsm} gsm"
    body       :quote => quote
    content_type "text/html"
  end

  def password_reset user
    recipients user.email
    from       "partners@cello.com.au"
    subject    "Cello password reset for #{user.username}"
    body       :user => user
    
  end
  
  def quote_report quotes
    recipients  Settings.reports.mail_to
    from        "partners@cello.com.au"
    subject     "Today's Quotes - #{Date.yesterday}"
    body    :quotes => quotes
    content_type "text/html"
  end

  def order_report orders
    recipients  Settings.reports.mail_to
    from        "partners@cello.com.au"
    subject     "Today's Orders - #{Date.yesterday}"
    body    :orders => orders
    content_type "text/html"
  end

end
