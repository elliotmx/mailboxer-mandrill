class Mailboxer::MessageMailer < Mailboxer::BasemandrillMailer
  #Sends and email for indicating a new message or a reply to a receiver.
  #It calls new_message_email if notifing a new message and reply_message_email
  #when indicating a reply to an already created conversation.
  def send_email(message, receiver)
    if message.conversation.messages.size > 1
      reply_message_email(message,receiver)
    else
      new_message_email(message,receiver)
    end
  end

  #Sends an email for indicating a new message for the receiver
  def new_message_email(message,receiver)
    @message  = message
    @receiver = receiver
    set_subject(message)
    
    merge_vars = {
      "FIRST_NAME" => "holo",
      "USER_URL" => "holo2",
    }

    body = mandrill_template("welcome", merge_vars)

    #mail :to => receiver.send(Mailboxer.email_method, message),
     #    :subject => t('mailboxer.message_mailer.subject_new', :subject => @subject),
      #   :template_name => 'new_message_email'

    send_mandrill_mail(receiver.send(Mailboxer.email_method, message), subject, body)
  end

  #Sends and email for indicating a reply in an already created conversation
  def reply_message_email(message,receiver)
    @message  = message
    @receiver = receiver
    set_subject(message)
    #mail :to => receiver.send(Mailboxer.email_method, message),
     #    :subject => t('mailboxer.message_mailer.subject_reply', :subject => @subject),
      #   :template_name => 'reply_message_email'

    merge_vars = {
      "FIRST_NAME" => "holo",
      "USER_URL" => "holo2",
    }
    
      send_mandrill_mail(receiver.send(Mailboxer.email_method, message), subject, body)

  end
end
