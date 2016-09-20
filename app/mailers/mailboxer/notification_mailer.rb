class Mailboxer::NotificationMailer < Mailboxer::BasemandrillMailer
  #Sends an email for indicating a new notification to a receiver.
  #It calls new_notification_email.
  def send_email(notification, receiver)
    new_notification_email(notification, receiver)
  end

  #Sends an email for indicating a new message for the receiver
  def new_notification_email(notification, receiver)
    @notification = notification
    @receiver     = receiver
    set_subject(notification)
   # mail :to => receiver.send(Mailboxer.email_method, notification),
    #     :subject => t('mailboxer.notification_mailer.subject', :subject => @subject),
     #    :template_name => 'new_notification_email'

    merge_vars = {
      "FIRST_NAME" => "holo",
      "USER_URL" => "holo2",
    }

     body = mandrill_template("welcome", merge_vars)
    
      send_mandrill_mail(receiver.send(Mailboxer.email_method, message), @subject, body)

  end
end
