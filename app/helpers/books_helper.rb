module BooksHelper
  def author_link_with_comma author, last_author
    "#{author.name}#{', ' unless author == last_author}"
  end

  def find_author_id_by_name author_name
    author_found = Author.find_by(name: author_name)
    return if author_found.blank?

    author_found.id
  end

  def book_sorting_options
    [
      [t(".newest"), "created_at desc"],
      [t(".oldest"), "created_at asc"],
      [t(".A-Z"), "title asc"],
      [t(".Z-A"), "title desc"]
    ]
  end
end
