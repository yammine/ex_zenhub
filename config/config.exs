use Mix.Config

config :ex_zenhub, :auth, System.get_env("ZENHUB_TOKEN")
