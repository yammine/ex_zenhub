defmodule ExZenHub.API.Base do
  @moduledoc """
  Provides common functions for different ZenHub API resources
  """

  @spec request(:get | :post | :put | :patch | :delete, String.t, Keyword.t, Keyword.t) :: {:ok, Map.t | String.t} | {:error, any()}
  def request(method, path, params \\ [], opts \\ []) do
    do_request(method, request_url(path), params, opts)
  end

  defp do_request(method, url, params, opts) do
    ExZenHub.Config.get
    |> verify_auth
    |> ExZenHub.HTTP.request(method, url, params, opts)
    |> parse_response
  end

  defp request_url(path) do
    "https://api.zenhub.io/p1/#{path}"
  end

  defp verify_auth(auth) when is_binary(auth), do: {:ok, auth}
  defp verify_auth(_) do
    {:error, %ExZenHub.Error{code: 500, message: "ZenHub Auth Token is not set. Use ExZenHub.configure to set it."}}
  end

  defp parse_response({:error, _} = err), do: err
  defp parse_response({:ok, response}) do
    # TODO: Chris - Handle 403 Rate Limit errors
    case response do
      %HTTPoison.Response{body: body, status_code: code} when code >= 200 and code < 300 ->
        Poison.decode(body, keys: :atoms)
      %HTTPoison.Response{body: body, status_code: code} ->
        {:error, %ExZenHub.Error{code: code, message: body}}
    end
  end
end
