defmodule Explore.IndexerTest do
  use ExUnit.Case, async: true
  require Explore.Indexer, as: I

  test "some method without param" do
    assert I.some_method == {:ok}
  end

  test "some method with param" do
    assert I.some_method(1) == {:ok, [1]}
  end
end
