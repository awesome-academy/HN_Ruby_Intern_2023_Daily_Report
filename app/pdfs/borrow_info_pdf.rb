class BorrowInfoPdf < Prawn::Document
  def initialize borrow_info
    super()
    default_options

    @borrow_info = borrow_info

    header
    content
    footer
  end

  private

  def default_options
    font_size 14

    font_path = [Rails.root, "vendor", "fonts"].join("/")
    font_families.update(
      "Roboto" => {
        normal: "#{font_path}/Roboto-Regular.ttf",
        bold: "#{font_path}/Roboto-Bold.ttf",
        italic: "#{font_path}/Roboto-Italic.ttf",
        bold_italic: "#{font_path}/Roboto-BoldItalic.ttf"
      }
    )
    font "Roboto"
  end

  def header
    text "LIBMA", size: 18
    text I18n.t("pdf_borrow_info") + "##{@borrow_info.id}",
         size: 26, style: :bold, align: :center
  end

  def content
    stroke_style
    user_info_view
    borrow_info_view
    book_borrowed_view
  end

  def user_info_view
    bounding_box([0, 620], width: 250) do
      header_text I18n.t("pdf_user_info")
      section_text "Email: #{@borrow_info.account.email}"
      section_text I18n.t("pdf_username") + ": #{@borrow_info.account.username}"
    end
  end

  def borrow_info_view
    bounding_box([300, 620], width: 250) do
      header_text I18n.t("pdf_borrow_info")
      section_text I18n.t("pdf_borrow_date") + ": #{@borrow_info.start_at}"
      section_text I18n.t("pdf_return_date") + ": #{@borrow_info.end_at}"
      section_text I18n.t("pdf_renewal_used") + ": #{@borrow_info.turns}"
    end
  end

  def book_borrowed_view
    stroke_style
    header_text I18n.t("pdf_borrowed_books")
    book_table
  end

  def footer
    text "#{I18n.t('copyright')} LIBMA", align: :center, valign: :bottom
  end

  def header_text t_params
    text t_params, size: 16, style: :bold
    move_down 10
  end

  def section_text t_params
    text t_params, indent_paragraphs: 10
    move_down 5
  end

  def stroke_style
    move_down 30
    stroke_horizontal_rule
    move_down 20
  end

  def book_table
    table = book_table_data
    render_table(table)
  end

  def book_table_data
    table_data = book_table_headers

    @borrow_info.books.includes([:publisher]).each_with_index do |book, index|
      table_data << [
        index + 1,
        book.title.to_s,
        book.isbn.to_s,
        book.publisher.name.to_s
      ]
    end

    table_data
  end

  def book_table_headers
    table_headers = %w(pdf_no pdf_title pdf_isbn pdf_publisher).map do |header|
      I18n.t(header.downcase)
    end

    [table_headers]
  end

  def render_table data
    table(data, width: bounds.width) do
      cells.padding = 12
      row(0).font_style = :bold
    end
  end
end
