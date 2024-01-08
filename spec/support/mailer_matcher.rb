# spec/support/mailer_matcher.rb
require "rspec/expectations"

RSpec::Matchers.define :email_with do |mailer_action, *expected_args|
  match do |mailer_class|
    message_delivery = instance_double(ActionMailer::MessageDelivery)
    expect(mailer_class).to receive(:with) do |*args|
      expected_args.each_with_index do |exp, i|
        expect(args[i]).to eq exp
      end
    end
    expect(mailer_class).to receive(mailer_action).and_return(message_delivery)
    allow(message_delivery).to receive(:deliver_later)
  end
end
