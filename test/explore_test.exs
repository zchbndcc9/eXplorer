defmodule ExploreTest do
  use ExUnit.Case
  doctest Explore

  test "greets the world" do
    assert Explore.hello() == :world
  end
end
