defmodule ExZenHub.Epics do
  import ExZenHub.API.Base

  def all(repo_id, opts \\ []) do
    request(:get, "repositories/#{repo_id}/epics", [], opts)
    |> ExZenHub.Parser.parse(:epics)
  end

  def get(repo_id, issue_number, opts \\ []) do
    request(:get, "repositories/#{repo_id}/epics/#{issue_number}", [], opts)
    |> ExZenHub.Parser.parse(:epic)
  end
end
