use Mix.Config

config :ex_zen_hub, :auth, System.get_env("ZENHUB_TOKEN")
