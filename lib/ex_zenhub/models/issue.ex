defmodule ExZenHub.Issue do
  defstruct estimate: nil, is_epic: nil, issue_number: nil, position: nil
  @type t :: %__MODULE__{}
end
