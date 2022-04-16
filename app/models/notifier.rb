class Notifier < ActionMailer::Base
  helper :orders
  def quote quote
    recipients quote.email.blank? ? (UserSession.find && UserSession.find.user).email : quote.email
    from       Setting.smtp_sender_address
    cc         Setting.smtp_quote_cc_address if quote.is_a?(Order)
    subject    "#{quote.organisation_name} #{quote.class.to_s.downcase} for #{quote.grade_name} #{quote.calliper} um #{quote.gsm} gsm"
    body       :quote => quote
    content_type "text/html"
  end

  def password_reset user
    recipients user.email
    from       Setting.smtp_sender_address
    subject    "Cello password reset for #{user.username}"
    body       :user => user

  end

  def quote_report quotes
    recipients  Setting.reports.mail_to
    from        Setting.smtp_sender_address
    subject     "Today's Quotes - #{Date::DAYNAMES[Date.yesterday.wday]} #{Date.yesterday}"
    body    :quotes => quotes
    content_type "text/html"
  end

  def order_report orders
    recipients  Setting.reports.mail_to
    from        Setting.smtp_sender_address
    subject     "Today's Orders - #{Date::DAYNAMES[Date.yesterday.wday]} #{Date.yesterday}"
    body    :orders => orders
    content_type "text/html"
  end

  def out_of_stock_alert quote
    recipients  Setting.out_of_stock_alert.mail_to
    from        Setting.smtp_sender_address
    subject    "Out of stock #{quote.class.to_s.downcase} processed for #{quote.organisation_name} : #{quote.grade_name} #{quote.calliper} um #{quote.gsm} gsm"
    body       :quote => quote
    content_type "text/html"
  end
end
