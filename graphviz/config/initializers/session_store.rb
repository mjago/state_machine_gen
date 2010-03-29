# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_graphviz_session',
  :secret      => '6fa90b47eebe8b44c1cb81aa38585706b5ac4799cb281f492bfb0af64e02749983eaffd6be8cb86a5bd0359afc13befecd828a07494b8f798c58ce00bfb2ca4d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
