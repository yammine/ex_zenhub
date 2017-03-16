defmodule ExZenHub.Event do
  defstruct created_at: nil, user_id: nil, type: nil, changes: nil
  @type t :: %__MODULE__{}

  @common ~w(created_at user_id type)a

  @spec from_map(Map.t) :: t
  def from_map(%{created_at: created_at, user_id: user_id, type: type} = object) do
    changes = Map.drop(object, @common)
    %__MODULE__{created_at: created_at, user_id: user_id, type: type, changes: changes}
  end
end
