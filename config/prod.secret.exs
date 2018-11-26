use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :lani, LaniWeb.Endpoint,
  secret_key_base: "u0cHeluq7RHgtwmvfVGYn+f5fSVYlqLBwLwQq3wsxUD87nC9D7I2mEQoumC64XB3"

# Configure your database
config :lani, Lani.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "Lanilans",
  database: "lani_prod",
  hostname: "104.248.146.100",
  # hostname could be kunvince.com
  pool_size: 15

