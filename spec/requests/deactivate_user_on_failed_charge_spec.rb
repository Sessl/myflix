require 'spec_helper'

describe 'Deactivate user on failed charge' do
 let(:event_data) do 
  {
    "id"=> "evt_18TxRYLEtKgthVSvrRdF7hGC",
    "object"=> "event",
    "api_version"=> "2016-02-29",
    "created"=> 1467740084,
    "data"=> {
      "object"=> {
        "id"=> "ch_18TxRYLEtKgthVSvp0qhuws2",
        "object"=> "charge",
        "amount"=> 999,
        "amount_refunded"=> 0,
        "application_fee"=> nil,
        "balance_transaction"=> nil,
        "captured"=> false,
        "created"=> 1467740084,
        "currency"=> "usd",
        "customer"=> "cus_8fxuUhIlBb5EqG",
        "description"=> "another failed payment",
        "destination"=> nil,
        "dispute"=> nil,
        "failure_code"=> "card_declined",
        "failure_message"=> "Your card was declined.",
        "fraud_details"=> {},
        "invoice"=> nil,
        "livemode"=> false,
        "metadata"=> {},
        "order"=> nil,
        "paid"=> false,
        "receipt_email"=> nil,
        "receipt_number"=> nil,
        "refunded"=> false,
        "refunds"=> {
          "object"=> "list",
          "data"=> [],
          "has_more"=> false,
          "total_count"=> 0,
          "url"=> "/v1/charges/ch_18TxRYLEtKgthVSvp0qhuws2/refunds"
        },
        "shipping"=> nil,
        "source"=> {
          "id"=> "card_18TvCOLEtKgthVSvHMQ3awee",
          "object"=> "card",
          "address_city"=> nil,
          "address_country"=> nil,
          "address_line1"=> nil,
          "address_line1_check"=> nil,
          "address_line2"=> nil,
          "address_state"=> nil,
          "address_zip"=> nil,
          "address_zip_check"=> nil,
          "brand"=> "Visa",
          "country"=> "US",
          "customer"=> "cus_8fxuUhIlBb5EqG",
          "cvc_check"=> nil,
          "dynamic_last4"=> nil,
          "exp_month"=> 11,
          "exp_year"=> 2017,
          "fingerprint"=> "u63lpppmy7oAjJnA",
          "funding"=> "credit",
          "last4"=> "0341",
          "metadata"=> {},
          "name"=> nil,
          "tokenization_method"=> nil
        },
        "source_transfer"=> nil,
        "statement_descriptor"=> nil,
        "status"=> "failed"
      }
    },
    "livemode"=> false,
    "pending_webhooks"=> 1,
    "request"=> "req_8lUQhpZveNn1sf",
    "type"=> "charge.failed"
}
 end

 it "deactivates a user with the web hook data from stripe for a charge failed", :vcr do
  alice = Fabricate(:user, customer_token: "cus_8fxuUhIlBb5EqG")
  post "/stripe_events", event_data
  expect(alice.reload).not_to be_active
 end
end