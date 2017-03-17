defmodule ExZenHub.Epic do
  defstruct total_epic_estimates: nil, issues: nil, estimate: nil, pipeline: nil
  @type t :: %__MODULE__{}
end
