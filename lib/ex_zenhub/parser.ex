defmodule ExZenHub.Parser do
  @moduledoc """
  Turn responses from ZenHub into structs
  """
  @nested_resources ~w(pipeline pipelines issues epic_issues)a
  alias ExZenHub.{Board, Pipeline, Issue, EpicIssue, Event}

  @spec check_nested_resources(Map.t | any()) :: Map.t
  def check_nested_resources(object) when is_map(object) do
    arbitrarily_nested = Enum.reduce(object, %{}, fn
      {key, value}, acc when is_map(value) and not (key in @nested_resources) ->
        Map.put(acc, key, check_nested_resources(value))
      {key, value}, acc when is_list(value) and not (key in @nested_resources) ->
        Map.put(acc, key, Enum.map(value, &check_nested_resources/1))
      _, acc ->
        acc
    end)

    Map.merge(do_check(object, @nested_resources), arbitrarily_nested)
  end
  def check_nested_resources(anything_other_than_map), do: anything_other_than_map

  @spec do_check(Map.t, [Atom.t] | []) :: Map.t
  defp do_check(object, [r|rest]) do
    object
    |> preprocess(r)
    |> do_check(rest)
  end
  defp do_check(object, []), do: object

  defp preprocess(%{pipelines: pipelines} = object, :pipelines), do: Map.put(object, :pipelines, Enum.map(pipelines, &(parse({:ok, &1}, :pipeline))))
  defp preprocess(%{pipeline: pipeline} = object, :pipeline), do: Map.put(object, :pipeline, parse({:ok, pipeline}, :pipeline))
  defp preprocess(%{issues: issues} = object, :issues), do: Map.put(object, :issues, Enum.map(issues, &(parse({:ok, &1}, :issue))))
  defp preprocess(%{epic_issues: epic_issues} = object, :epic_issues), do: Map.put(object, :epic_issues, Enum.map(epic_issues, &(parse({:ok, &1}, :epic_issue))))
  defp preprocess(object, _), do: object

  def parse({:error, _} = err, _), do: err
  def parse({:ok, body}, :board) do
    body
    |> check_nested_resources
    |> (&(struct(Board, &1))).()
  end
  def parse({:ok, body}, :pipeline) do
    body
    |> check_nested_resources
    |> (&(struct(Pipeline, &1))).()
  end
  def parse({:ok, body}, :events) do
    body
    |> Enum.map(&Event.from_map/1)
  end
  def parse({:ok, body}, :epic_issue) do
    struct(EpicIssue, body)
  end
  def parse({:ok, body}, :epics) do
    body
    |> check_nested_resources # TODO: Maybe revisit how this is done
  end
  def parse({:ok, body}, :epic) do

  end
  def parse(tuple, atom, extra_data \\ [])
  def parse({:error, _} = err, _, _), do: err
  def parse({:ok, body}, :issue, extra_data) do
    body
    |> check_nested_resources
    |> merge_extra_data(extra_data)
    |> (&(struct(Issue, &1))).()
  end

  @spec merge_extra_data(Map.t, Keyword.t) :: Map.t
  defp merge_extra_data(object, []), do: object
  defp merge_extra_data(object, keyword) do
    keyword
    |> Enum.into(%{})
    |> Map.merge(object)
  end
end
