# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lazada,
  ecto_repos: [Lazada.Repo]

# Configures the endpoint
config :lazada, LazadaWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "5fM55HUXdEepSYIT2BDycU4ni5tdJunb7nFhLQmkLLgVdzdu3WwqP9ZdNsGwcV1z",
  render_errors: [view: LazadaWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Lazada.PubSub,
  live_view: [signing_salt: "/ECPDNWq"]

config :crawly,
  closespider_timeout: 10,
  concurrent_requests_per_domain: 8,
  middlewares: [
    Crawly.Middlewares.DomainFilter,
    Crawly.Middlewares.UniqueRequest,
    {Crawly.Middlewares.UserAgent, user_agents: ["Crawly Bot"]}
  ],
  pipelines: [
    {Crawly.Pipelines.Validate, fields: [:url, :title]},
    {Crawly.Pipelines.DuplicatesFilter, item_id: :title},
    Crawly.Pipelines.JSONEncoder,
    {Crawly.Pipelines.WriteToFile, extension: "jl", folder: "/tmp"}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


# csrftoken:"N8wDZwCnHfNjNPHyauonCbIxp0853EVD"
# G_AUTHUSER_H:"0"
# G_ENABLED_IDPS:"google"
# REC_T_ID:"bf6aa9b6-1c7a-11ec-968a-d4f5ef455105"
# SPC_CLIENTID:"VmlIR3NIeUdiZU5zvrkaxuzriiwflvbc"
# SPC_EC:"dDZHaEZ1bUxwdzRvYlNwMXwmyuU6dv4wC6eRQ3tpZR0tQPNbMk5bVrUDWF4gzP2Aj88dyXtRG5q4H/VlW4OTy6O104I003hRfZF7MNP4IyCHPgKc8MLFUvkx5pF4jIf9+3YhYgBzCoWMrvywo/uX7+q4zsSmNQlPmP3k6351/ac="
