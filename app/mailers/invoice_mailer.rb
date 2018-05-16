class InvoiceMailer < ActionMailer::Base

  add_template_helper HtmlTextHelper

  def send_invoice(ticket, invoice)
    @ticket = ticket
    @invoice = invoice
    title = 'New Invoice: ' + @ticket.subject.to_s
    
    add_attachments(@invoice)

    unless @ticket.message_id.blank?
      headers['Message-ID'] = "<#{@ticket.message_id}>"
    end

    mail(to: @invoice.customer_email, subject: title, from: 'admin@example.com')
  end

  protected

    def add_attachments(invoice)
      invoice.attachments.each do |at|
        attachments[at.file_file_name] = File.read(at.file.path)
      end
    end

end
