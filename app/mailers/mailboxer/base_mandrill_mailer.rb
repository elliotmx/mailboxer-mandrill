require "mandrill"

class BaseMandrillMailer < ActionMailer::Base
  default(
    :from => Mailboxer.default_from
    reply_to: "hello@example.com"
  )

  private

  def send_mandrill_mail(email, subject, body)
    mail(to: email, subject: subject, body: body, content_type: "text/html")
  end

  def mandrill_template(template_name, attributes)
    mandrill = Mandrill::API.new(ENV["SMTP_PASSWORD"])

    merge_vars = attributes.map do |key, value|
      { name: key, content: value }
    end

    mandrill.templates.render(template_name, [], merge_vars)["html"]
  end


  def set_subject(container)
    @subject  = container.subject.html_safe? ? container.subject : strip_tags(container.subject)
  end

  def strip_tags(text)
    ::Mailboxer::Cleaner.instance.strip_tags(text)
  end


end