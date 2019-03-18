defmodule ParserTest do
  use ExUnit.Case, async: true
  require Explore.Parser, as: P

  test "html without links results in empty list" do
    html = "<html></html>"
    assert P.extract_urls(html) == []
  end

  test "html with links" do
    html = "<html><body><a href=\"google.com\"><div><a href=\"facebook.com\"></div></body></html>"
    assert P.extract_urls(html) == ["facebook.com", "google.com"]
  end

  test "html with duplicate links" do
    html = "<html><body><a href=\"facebook.com\"><div><a href=\"facebook.com\"></div></body></html>"
    
    assert P.extract_unique_urls(html) == ["facebook.com"]
  end
end
