defmodule ExZenHub.Boards do
  import ExZenHub.API.Base

  def get(repo_id, opts \\ []) do
    request(:get, "repositories/#{repo_id}/board", [], opts)
    |> ExZenHub.Parser.parse(:board)
  end
end
