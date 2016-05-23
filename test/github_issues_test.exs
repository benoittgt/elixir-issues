defmodule GithubIssuesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  doctest Issues

  import Issues.GithubIssues

  setup_all do
    HTTPoison.start
  end

  test "get correct request" do
    use_cassette "github elixir-lang" do
      { status, _ } = fetch("elixir-lang", "elixir")
      assert status == :ok
    end
  end

  test "get incorrect request" do
    use_cassette "incorrect request" do
      { status, _ } = fetch("ellang", "eir")
      assert status == :ok
    end
  end
end
