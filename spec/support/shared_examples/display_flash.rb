shared_examples "displays flash message" do |flash_type, message|
  it "displays flash #{flash_type}" do
    expect(flash.now[flash_type]).to eq I18n.t(message)
  end
end
