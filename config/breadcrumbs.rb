crumb :root do
  link t("home"), root_path
end

crumb :books do
  link t("library"), books_path
end

crumb :book do |book|
  link book.title, book
  parent :books
end

crumb :borrow_infos do
  link t("borrow_info"), borrow_infos_path
end

crumb :borrow_info do |borrow_info|
  link borrow_info.id, borrow_info
  parent :borrow_infos
end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).
