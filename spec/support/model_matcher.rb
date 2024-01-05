RSpec::Matchers.define :be_a_clone_of do |model1|
  match do |model2|
    ignored_columns = %w[id created_at updated_at]
    model1.attributes.except(*ignored_columns) == model2.attributes.except(*ignored_columns)
  end
end
