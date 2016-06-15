Stripe.api_key = ENV['STRIPE_SECRET_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
  	user = User.where(customer_token: event.data.object.customer).first
    Payment.create(user: user)
  end

end