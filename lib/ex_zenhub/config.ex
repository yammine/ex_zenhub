defmodule ExZenHub.Config do
  @doc """
  Infer whether we should use global or local auth settings
  """
  def current_scope do
    if Process.get(:_ex_zenhub_auth, nil), do: :process, else: :global
  end

  @doc """
  Get the token to use for X-Auth-Token header
  """
  def get, do: get(current_scope())
  def get(:global) do
    Application.get_env(:ex_zenhub, :auth, nil)
  end
  def get(:process), do: Process.get(:_ex_zenhub_auth, nil)

  @doc """
  Set token value.
  """
  def set(value), do: set(current_scope(), value)
  def set(:global, value), do: Application.put_env(:ex_zenhub, :oauth, value)
  def set(:process, value) do
    Process.put(:_ex_zenhub_auth, value)
    :ok
  end
end
