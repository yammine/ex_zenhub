defmodule ExZenHub.Issue do
  defstruct estimate: nil, is_epic: nil, issue_number: nil, repo_id: nil, position: nil, plus_ones: nil, pipeline: nil
  @type t :: %__MODULE__{}
end

defmodule ExZenHub.EpicIssue do
  defstruct issue_number: nil, issue_url: nil, repo_id: nil
  @type t :: %__MODULE__{}
end
