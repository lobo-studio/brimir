class QuoteMailer < ActionMailer::Base

  add_template_helper HtmlTextHelper
  add_template_helper ApplicationHelper

  def send_quote(ticket, invoice)
    @ticket = ticket
    @invoice = invoice
    unless @ticket.message_id.blank?
      headers['Message-ID'] = "<#{@ticket.message_id}>"
    end

    mail(to: @invoice.customer_email, subject: 'Payment')
  end

end
