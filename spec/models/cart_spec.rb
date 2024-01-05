require 'rails_helper'

RSpec.describe Cart, type: :model do
  it { should have_many(:borrowings).class_name('BorrowItem').dependent(:destroy) }
  it { should have_many(:books).through(:borrowings) }
end
