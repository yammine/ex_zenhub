defmodule ExZenHub.Error do
  defstruct code: nil, message: nil
  @type t :: %__MODULE__{}
end
