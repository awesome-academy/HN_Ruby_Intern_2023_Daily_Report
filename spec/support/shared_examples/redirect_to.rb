shared_examples "redirects to" do |path|
  it "redirects to #{path}" do
    expect(response).to redirect_to public_send(path)
  end
end
