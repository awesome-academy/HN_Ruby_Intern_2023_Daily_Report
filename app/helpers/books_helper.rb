module BooksHelper
  def author_link_with_comma author, last_author
    "#{author.name}#{', ' unless author == last_author}"
  end

  def find_author_id_by_name author_name
    author_found = Author.find_by(name: author_name)
    return if author_found.blank?

    author_found.id
  end
end
