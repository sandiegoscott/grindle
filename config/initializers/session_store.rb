# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_hi_beta_092309_session',
  :secret      => 'f5b8e2ffa3d268cadf022d4e663b00bdbc9b2aeb43ced6ee2e128c5c01e5362b322afd3bc98a54e4100a8da77460b7a37ddaaa0e02bd4ff7ab17c0e7f1f2c853'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
