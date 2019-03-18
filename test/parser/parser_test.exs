defmodule ParserTest do
  use ExUnit.Case, async: true
  require Parser, as: P

  test "some method without param" do
    assert P.some_method == {:ok}
  end

  test "some method with param" do
    assert P.some_method(1) == {:ok, [1]}
  end
end
