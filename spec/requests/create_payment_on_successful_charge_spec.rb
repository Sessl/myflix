require 'spec_helper'

describe "Create payment on successful charge" do
  let(:event_data) do
    {
        "id" => "evt_18K9vALEtKgthVSvU56ziJrr",
        "object" => "event",
        "api_version" => "2016-02-29",
        "created" =>1465404768,
        "data" => {
          "object" => {
            "id" =>  "ch_18K9vALEtKgthVSvTN2llLj9",
            "object" => "charge",
            "amount" =>  999,
            "amount_refunded"=>  0,
            "application_fee"=>  nil,
            "balance_transaction"=> "txn_18K9vALEtKgthVSvMMqTCfSz",
            "captured"=>  true,
            "created"=>  1465404768,
            "currency"=>  "usd",
            "customer"=>  "cus_8bMeANGwCrOzom",
            "description"=>  nil,
            "destination"=>  nil,
            "dispute"=>  nil,
            "failure_code"=>  nil,
            "failure_message"=>  nil,
            "fraud_details"=>  {},
            "invoice"=>  "in_18K9vALEtKgthVSvUSmEJIXP",
            "livemode"=>  false,
            "metadata"=>  {},
            "order"=>  nil,
            "paid"=>  true,
            "receipt_email"=>  nil,
            "receipt_number"=>  nil,
            "refunded"=>  false,
            "refunds"=>  {
              "object"=>  "list",
              "data"=>  [],
              "has_more"=>  false,
              "total_count"=> 0,
              "url"=>  "/v1/charges/ch_18K9vALEtKgthVSvTN2llLj9/refunds"
            },
            "shipping"=>  nil,
            "source"=>  {
              "id"=>  "card_18K9v9LEtKgthVSvP0trOXMM",
              "object"=>  "card",
              "address_city"=>  nil,
              "address_country"=>  nil,
              "address_line1"=>  nil,
              "address_line1_check"=>  nil,
              "address_line2"=>  nil,
              "address_state"=>  nil,
              "address_zip"=>  nil,
              "address_zip_check"=>  nil,
              "brand"=>  "Visa",
              "country"=>  "US",
              "customer"=>  "cus_8bMeANGwCrOzom",
              "cvc_check"=>  "pass",
              "dynamic_last4"=>  nil,
              "exp_month"=>  6,
              "exp_year"=>  2018,
              "fingerprint"=>  "9aTT0lqdtJXxYmrk",
              "funding"=>  "credit",
              "last4"=>  "4242",
              "metadata"=>  {},
              "name"=>  nil,
              "tokenization_method"=>  nil
            },
            "source_transfer"=>  nil,
            "statement_descriptor"=>  nil,
            "status"=>  "succeeded"
          }
        },
        "livemode"=>  false,
        "pending_webhooks"=>  1,
        "request"=>  "req_8bMeT4SnahZNei",
        "type"=>  "charge.succeeded"
      }
  end

	it "creates a payment with the webhook from stripe for charge succeeded", :vcr do 
    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_8bMeANGwCrOzom")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end
end