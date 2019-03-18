defmodule ParserTest do
  use ExUnit.Case, async: true
  require Parser, as: P

  test "html without links results in empty list" do
    html = "<html></html>"
    assert P.extract_urls(html) == []
  end

  test "some method with param" do
    html = "<html><body><a href=\"google.com\"><div><a href=\"facebook.com\"></div></body></html>"
    assert P.extract_urls(html) == ["google.com", "facebook.com"]
  end
end
