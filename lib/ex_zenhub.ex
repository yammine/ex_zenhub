defmodule ExZenHub do
  @moduledoc """
  Provides convenience for accessing the ZenHub API.
  """

  @doc """
  Provides authorization configuration.

  The default behavior is global configuration. For configuration localized to a process see `ExZenHub.configure/2`

  ## Examples

      ExZenHub.configure(System.get_env("ZENHUB_TOKEN"))
  """
  @spec configure(String.t) :: :ok
  defdelegate configure(auth), to: ExZenHub.Config, as: :set

  @doc """
  Provides authorization configuration with the option for keeping it localized to the current process.

  ## Options

    The `scope` can have one of the following values.

    * `:global` - configuration is shared for all processes (unless they have locally configured auth).

    * `:process` - configuration is isolated for each process.

  ## Examples

      ExZenHub.configure(:process, System.get_env("ZENHUB_TOKEN"))

  """
  @spec configure(:global | :process, String.t) :: :ok
  defdelegate configure(scope, oauth), to: ExZenHub.Config, as: :set

end
