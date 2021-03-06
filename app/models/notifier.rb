class Notifier < ActionMailer::Base
  helper :orders
  def quote quote
    recipients quote.email.blank? ? (UserSession.find && UserSession.find.user).email : quote.email
    from       "partners@cello.com.au"
    cc         "sales@cello.com.au" if quote.is_a?(Order)
    subject    "#{quote.organisation_name} #{quote.class.to_s.downcase} for #{quote.grade_name} #{quote.calliper} um #{quote.gsm} gsm"
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
    subject     "Today's Quotes - #{Date::DAYNAMES[Date.yesterday.wday]} #{Date.yesterday}"
    body    :quotes => quotes
    content_type "text/html"
  end

  def order_report orders
    recipients  Settings.reports.mail_to
    from        "partners@cello.com.au"
    subject     "Today's Orders - #{Date::DAYNAMES[Date.yesterday.wday]} #{Date.yesterday}"
    body    :orders => orders
    content_type "text/html"
  end

  def out_of_stock_alert quote
    recipients  Settings.out_of_stock_alert.mail_to
    from       "partners@cello.com.au"
    subject    "Out of stock #{quote.class.to_s.downcase} processed for #{quote.organisation_name} : #{quote.grade_name} #{quote.calliper} um #{quote.gsm} gsm"
    body       :quote => quote
    content_type "text/html"
  end
end
