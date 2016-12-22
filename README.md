# README

## Ruby-on-Rails Sample Braintree Integration

This is a simple app I put together to do a sample integration with Braintree's payment software.

### Installation
1. Ensure that you have Rails installed
2. Pull the source down with `git clone https://github.com/MVanderwood/braintree-integration-rails.git`
3. In the `/braintree-integration-rails` directory, run `bundle install` to install the needed dependencies
4. You'll also need a set of API keys and a merchant ID from Braintree. You can get those [here](https://www.braintreegateway.com/login)
5. You'll also need to include a `.env` file with all the api information. It should be located in the root directory; ie `/braintree-integration-rails/.env` and should look like this:

```
BRAINTREE_ENV=sandbox
BRAINTREE_MERCH_ID=<<Your Merchant ID>>
BRAINTREE_PUB_KEY=<<Your Public API Key>>
BRAINTREE_PRIV_KEY=<<Your Private API Key>>

```

### Running the Tests
If the above is done, the tests should't require any additional setup. Run `bin/rspec` to run them.

### Using the App
1. Spin up a server by running `rails server`
2. The site should be available at localhost:3000
3. At the root you can submit payment information, which will be submitted to Braintree's sandbox environment for processing. Default fake payment info is in the form as a placeholder, but Braintree has an [array of payment](https://developers.braintreepayments.com/reference/general/testing/ruby) info available to test different responses.

### Notes
The payment amount is currently hardcoded in at $10, you'll have to alter the source if you want to test other amounts.
This is just a sandbox integration to play around with Braintree's payment software, so I didn't take much time to pretty up the view.
