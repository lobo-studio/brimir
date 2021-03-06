require 'prawn'
require 'date'

class InvoicePdf

  def generate(ticket, invoice)
    pdf = Prawn::Document.new

    pdf.font "Helvetica"

    # Defining the grid 
    # See http://prawn.majesticseacreature.com/manual.pdf
    pdf.define_grid(:columns => 5, :rows => 8, :gutter => 10) 

    g1 = pdf.grid([0,0], [1,1]).bounding_box do 
      pdf.text  "INVOICE", :size => 18
      pdf.text "Invoice No: #{invoice.id}", :align => :left
      
      invoice_date = if invoice.invoice_date
        invoice.invoice_date.strftime("%Y/%m/%d")
      else
        DateTime.now.strftime("%Y/%m/%d %H:%M")
      end

      pdf.text "Date: #{invoice_date}", :align => :left
      pdf.move_down 10
      
      pdf.text "Attn: Any text "
      pdf.text invoice.customer_email
      pdf.text "Tel No: 1234567890"
      pdf.text "Fax No: 1234567890"
    end

    g2 = pdf.grid([0,3.6], [1,4]).bounding_box do 
      # Assign the path to your file name first to a local variable.
      logo_path = File.expand_path('../images/logo.png', __FILE__)

      # Displays the image in your PDF. Dimensions are optional.
      pdf.image logo_path, :width => 50, :height => 50, :position => :left

      # Company address
      pdf.move_down 10
      pdf.text "Mesbesoinsmoto LLC", :align => :left
      pdf.text "Address", :align => :left
      pdf.text "Street 1", :align => :left
      pdf.text "40300 France", :align => :left
      pdf.text "Paris", :align => :left
      pdf.text "Tel No: 1234567890", :align => :left
      pdf.text "Fax No: 1234567890", :align => :left
    end

    pdf.text "Details of Invoice", :style => :bold_italic
    pdf.stroke_horizontal_rule


    temp_arr = invoice.invoice_items.map { |i| i.attributes }

    pdf.move_down 10
    items = [["Description", "Qt.", "PU HT", "Montant HT", "TVA"]]

    data = temp_arr.each_with_index.map do |item, i|
      [
        item['title'],
        item['quantity'],
        item['unit_price'],
        item['unit_price'] * item['quantity'],
        item['tax'],
      ]
    end

    items += data

    mntht = data.map { |x| x[3] }.sum
    
    tva = data.map { |x| x[4] }.sum
    #items += [["", "Montant total HT", "", "", "", mntht.to_s]]
    #items += [["", "Montant total TVA", "", "", "", tva.to_s]]
    #items += [["", "Montant total TTC", "", "", "", (mntht + tva).to_s]]

    t1 = pdf.table items, :header => true, 
      :column_widths => { 0 => 310, 1 => 40, 2 => 50, 3 => 80, 4 => 50}, :row_colors => ["d2e3ed", "FFFFFF"] do
        style(columns(3)) { |x| x.align = :right }
    end

    pdf.bounding_box([pdf.bounds.right - 180, pdf.bounds.height - g1.height - g2.height - t1.height + 80], :width => 250, :height => 100) do
      pdf.text "Montant total HT              #{mntht.to_s}" #, :align => :right
      pdf.text "Montant total TVA            #{tva.to_s}" #, :align => :right
      pdf.text "....................................................." #, :align => :right
      pdf.text "Montant total TTC            #{(mntht + tva).to_s}" #, :align => :right
    end




    # pdf.move_down 20
    # pdf.text "..............................."
    # pdf.text "Signature/Company Stamp"

    # pdf.move_down 10
    # pdf.stroke_horizontal_rule

    pdf.bounding_box([pdf.bounds.right - 50, pdf.bounds.bottom], :width => 60, :height => 20) do
      pagecount = pdf.page_count
      pdf.text "Page #{pagecount}"
    end

    pdf.render_file "public/invoices/invoice_#{ticket.id}.pdf"
  end

end