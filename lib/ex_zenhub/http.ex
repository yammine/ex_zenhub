defmodule ExZenHub.HTTP do
  @moduledoc """
  HTTP convenience module

  See https://hexdocs.pm/httpoison/HTTPoison.html#request/5 for list of `opts`
  """

  @spec request({:ok | :error, String.t | ExZenHub.Error.t}, :get | :post | :put | :patch | :delete, String.t, Keyword.t, Keyword.t) :: {:ok, HTTPoison.Response.t} | {:error, HTTPoison.Error.t}
  def request({:error, _} = err, _, _, _, _), do: err
  def request({:ok, auth_token}, method, url, params, opts) do
    authorization_header = {"X-Authentication-Token", auth_token}
    case method do
      :get ->
        HTTPoison.get(url <> "?#{URI.encode_query(params)}", [authorization_header], opts)
      _ ->
        HTTPoison.request(method, url, {:form, params}, [authorization_header], opts)
    end
  end
end
