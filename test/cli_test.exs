defmodule CliTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney
  import ExUnit.CaptureIO
  doctest Issues

  import Issues.CLI, only: [ main: 1,
                             parse_args: 1,
                             sort_into_ascending_order: 1,
                             convert_to_list_of_maps: 1 ]

  setup_all do
    HTTPoison.start
  end

  test ":help returnd by options parsing with -h and --help options" do
    assert parse_args(["-h", "anything"]) == :help
  end

  test "three values returned if three given" do
    assert parse_args(["user", "project", "99"]) == { "user", "project", 99 }
  end

  test "count if defaulted if two values given" do
    assert parse_args(["user", "project"]) == { "user", "project", 4 }
  end

  test "sort ascending orders the correct way" do
    result = sort_into_ascending_order(fake_created_list(["c", "a", "b"]))
    issues = for issue <- result, do: issue["created_at"]
    assert issues == ~w{a b c}
  end

  defp fake_created_list(values) do
    data = for value <- values,
           do: [{"created_at", value}, {"other_data", "xxx"}]
    convert_to_list_of_maps data
  end

  test "test full chain" do
    use_cassette "github elixir-lang 3 results" do
      result = capture_io fn ->
        main(["elixir-lang", "elixir", "3"])
      end
      assert :ok == main(["elixir-lang", "elixir", "3"])
      assert result == """
      numb | created_at           | title                                                      
      -----+----------------------+------------------------------------------------------------
      3011 | 2015-01-11T17:06:06Z | Discuss if we should support monitoring callbacks in agents
      3254 | 2015-04-07T22:12:11Z | Do not allow tuple.foo calls anymore                       
      3268 | 2015-04-14T08:11:29Z | Warn if variable is used as function call                  
      """
    end
  end
end
