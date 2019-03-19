defmodule Explore.FetcherTest do
  use ExUnit.Case, async: true
  require Explore.Fetcher, as: F

  test "some method without param" do
    {status, _} = F.fetch("www.google.com")
    assert status == :ok 
  end
end
