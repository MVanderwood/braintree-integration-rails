Dotenv.load

Braintree::Configuration.environment = ENV["BRAINTREE_ENV"].to_sym
Braintree::Configuration.merchant_id = ENV["BRAINTREE_MERCH_ID"]
Braintree::Configuration.public_key = ENV["BRAINTREE_PUB_KEY"]
Braintree::Configuration.private_key = ENV["BRAINTREE_PRIV_KEY"]
