defmodule ExZenHubTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest ExZenHub

  setup_all do
    HTTPoison.start # Ensure :httpoison is started.

    ExVCR.Config.filter_request_headers("X-Authentication-Token")
    ExVCR.Config.filter_sensitive_data("connect.sid=.+;", "<REMOVED>")
    ExVCR.Config.cassette_library_dir("fixtures/vcr_cassettes", "fixtures/custom_cassettes")

    ExZenHub.configure(System.get_env("ZENHUB_TOKEN"))
    :ok
  end

  test "Gets current configuration" do
    assert is_binary(ExZenHub.Config.get)
  end

  describe "Get issue data" do
    test "GET issue - success" do
      use_cassette "get-issue-success" do
        {:ok, issue} = ExZenHub.Issues.get(85001897, 3)
        assert match?(%ExZenHub.Issue{issue_number: 3}, issue)
      end
    end

    test "GET issue - failure (not found)" do
      use_cassette "get-issue-not-found" do
        {:error, error} = ExZenHub.Issues.get(85001897, 35198412958461596)
        assert match?(%ExZenHub.Error{code: 404, message: "Issue not found"}, error)
      end
    end

    test "GET issue events - success" do
      use_cassette "get-issue-events-success" do
        {:ok, events} = ExZenHub.Issues.events(85001897, 3)
        assert is_list(events)
        assert match?([%ExZenHub.Event{}|_], events)
      end
    end

    test "GET issue events - failure" do
      use_cassette "get-issue-events-failure" do
        # At the time of this test, fetching events for an issue that doesn't exist returns an empty list
        # instead of the "Issue not found" error we see above when attempting to fetch issue data
        {:ok, empty_list} = ExZenHub.Issues.events(85001897, 9999999999999)
        assert is_list(empty_list)
        assert empty_list == []
      end
    end
  end

  describe "Get board data" do
    test "GET board - success" do
      use_cassette "get-board-success" do
        {:ok, board} = ExZenHub.Boards.get(85001897)
        assert match?(%ExZenHub.Board{pipelines: _}, board)
      end
    end

    test "GET board - failure (no pull access)" do
      use_cassette "get-board-no-pull-access" do
        {:error, error} = ExZenHub.Boards.get(12345)
        assert error.code == 404
        assert match?("No 'pull' access for this Repo" <> _, error.message)
      end
    end
  end
end
