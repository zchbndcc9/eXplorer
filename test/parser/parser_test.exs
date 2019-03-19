defmodule ParserTest do
  use ExUnit.Case, async: true
  require Explore.Parser, as: P

  describe "Extracting urls when" do
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
  
  describe "Extracting indexes when" do
    test "basic html" do
      html = """
      <body>
        <h1>hello there my name is Zach</h1>
        <div>
          <p>There goes Jim</p>
        </div>
      </body>
      """

      expected = ["goes", "hello", "is", "jim", "my", "name", "there", "zach"]
      assert P.extract_indexes(html, stem: false) == expected 
    end

    test "basic html with unique indexes" do
      html = """
      <body>
        <h1>hello there my name is Zach</h1>
        <div>
          <p>There goes my name is Zach Jim</p>
        </div>
      </body>
      """ 
      
      expected = ["goes", "hello", "is", "jim", "my", "name", "there", "zach"]
      assert P.extract_indexes(html, stem: false) == expected 
    end

    test "normalize text" do
      html = """
      <body>
       <h1>heLLo there my name is Zach</h1>
        <div>
          <p>THERE goEs Jim</p>
        </div>
      </body>
      """ 

      expected = ["goes", "hello", "is" ,"jim", "my", "name", "there", "zach"]
      assert P.extract_indexes(html, stem: false) == expected 
    end
  end
end
