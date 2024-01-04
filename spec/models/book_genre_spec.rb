require 'rails_helper'

RSpec.describe BookGenre, type: :model do
  it { should belong_to(:genre).class_name('Genre') }
  it { should belong_to(:book).class_name('Book') }
end
