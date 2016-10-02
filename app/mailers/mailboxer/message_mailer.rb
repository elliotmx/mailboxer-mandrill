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
    
    puts "new message"
    puts "#{@message.inspect}"
    puts "#{@receiver.inspect}"

    merge_vars = {
      "MESSAGE" => @message.body,
      "SENDER" => Spree::User.find(@message.sender_id).first_name
    }

    body = mandrill_template("new_inbox_message", merge_vars)

    #mail :to => receiver.send(Mailboxer.email_method, message),
     #    :subject => t('mailboxer.message_mailer.subject_new', :subject => @subject),
      #   :template_name => 'new_message_email'

    send_mandrill_mail(receiver.send(Mailboxer.email_method, message), @subject, body)
  end

  #Sends and email for indicating a reply in an already created conversation
  def reply_message_email(message,receiver)
    @message  = message
    @receiver = receiver
    set_subject(message)

    puts "reply message"
    puts "#{@message.inspect}"
    puts "#{@receiver.inspect}"

    #mail :to => receiver.send(Mailboxer.email_method, message),
     #    :subject => t('mailboxer.message_mailer.subject_reply', :subject => @subject),
      #   :template_name => 'reply_message_email'

    merge_vars = {
      "MESSAGE" => @message.body,
      "SENDER" => Spree::User.find(@message.sender_id).first_name
    }
    
     body = mandrill_template("new_inbox_message", merge_vars)
     
      send_mandrill_mail(receiver.send(Mailboxer.email_method, message), @subject, body)

  end
end
