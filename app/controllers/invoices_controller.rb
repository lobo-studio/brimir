require 'invoice_pdf'

class InvoicesController < ApplicationController
 
  include InvoicesStrongParams

  before_action :authenticate_user!, except: [:create, :new]
  load_and_authorize_resource :invoice, except: :create
  skip_authorization_check only: :create

  def new
    @invoice = Invoice.new
    @ticket = Ticket.find(params[:ticket_id])
  end

  def create
    @invoice = Invoice.new(invoice_params)
    @ticket = Ticket.find(params[:ticket_id])
    @invoice.ticket = @ticket
    if @invoice.save
      pdf = InvoicePdf.new.generate(@ticket, @invoice)
      file = File.open(Rails.root.join('public', 'invoices', "invoice_#{@ticket.id}.pdf"))
      @invoice.attachments << Attachment.create(file: file)
      data = @invoice.invoice_items
      montant_total_ht = data.map { |x| x.unit_price * x.quantity }.sum
      montant_total_tva = data.map { |x| x.tax }.sum
      montant_total_ttc = montant_total_ht + montant_total_tva
      PaymentRequest.create(ticket: @ticket, status: :pending, 
        montant_total_ht: montant_total_ht, 
        montant_total_tva: montant_total_tva,
        montant_total_ttc: montant_total_ttc)
      QuoteMailer.send_quote(@ticket, @invoice).deliver_now
      redirect_to tickets_url, notice: I18n::translate(:invoices_added)
    else
      render :new
    end
  end
end
