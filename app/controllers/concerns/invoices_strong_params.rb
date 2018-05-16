module InvoicesStrongParams
  extend ActiveSupport::Concern
  protected
  def invoice_params
    params.require(:invoice).permit(
      :customer_address,
      :customer_email,
      :invoice_date,
      invoice_items_attributes: [
        :id,
        :_destroy,
        :title,
        :quantity,
        :amount,
        :tax
      ]
    )
  end
end
