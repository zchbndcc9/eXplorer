defmodule Explore.Parser do
  alias Explore.Document
  @doc """
  Extracts a list of links and indexes from html and returns a map that wraps the lists
  
  ## Examples
  
    iex> Explore.Parser.extract("<html><title>Hello there</html><body><a href='google.com'><div><a href='facebook.com'></div><p>hello there I am Zach</p></body></html>")
    %{
      indexes: ["am", "hello", "i", "there", "zach"],
      links: ["facebook.com","google.com"],
      title: "Hello there"
    }
  """
  def extract(doc = %Document{ status: :ok }, opts \\ [stem: true]) do
    links_task = Task.async(fn -> extract_unique_urls(doc) end)
    terms_task = Task.async(fn -> extract_terms(doc, opts) end)
    title_task = Task.async(fn -> extract_title(doc) end)

    %Document{
      doc | 
      terms: Task.await(terms_task),
      links: Task.await(links_task),
      title: Task.await(title_task)
    }
  end

  def extract(doc, _) do
    doc
  end
  
  @doc """
  Will extract a list of all urls within html and return the list in alphebetical order

  ## Examples
    
    iex> Explore.Parser.extract_urls("<body><a href='google.com'><div><a href='facebook.com'></div></body>")
    ["facebook.com", "google.com"] 
  """
  def extract_urls(%Document{ type: :text }) do
    [] 
  end
  
  def extract_urls(%Document{ content }) do
    content 
    |> Floki.find("a")
    |> Floki.attribute("href")
    |> Enum.sort()
  end

  @doc """
  Extracts a list of unique links within html and return the list in alphebetical order

  ## Examples
    
    iex> Explore.Parser.extract_unique_urls("<body><a href='google.com'></a><a href='google.com'>Google</a></body>")
    ["google.com"]
  """
  def extract_unique_urls(%Document{ }) do
    []
  end

  def extract_unique_urls(%Document{ content }) do
    content 
    |> extract_urls()
    |> Enum.uniq()
  end

  @doc """
  Extracts all indexes with html and returns the list of stemmed words in alphebetical order

  By default the function will stem the words, but a `stem` flag can be supplied in order to prevent the words from being stemmed
  """
  def extract_terms(%Document{ type: :text, content }, opts \\ [stem: true]) do
    content
    |> extract_terms(opts)
  end

  def extract_terms(%Document{ content }, opts \\ [stem: true]) do
    content 
    |> filter_html(["noscript", "style"]) 
    |> Floki.text(sep: " ")
    |> extract_terms(opts)
  end

  def extract_terms(text, opts \\ [stem: true]) do
    text
    |> String.split(" ")
    |> normalize_terms(opts)
    |> Enum.sort()
  end

  @doc """
  Filters out the provided tags from the html
  """
  def filter_html(html, []),         do: html 
  def filter_html(html, [tag | t]),  do: Floki.filter_out(filter_html(html, t), tag)
  
  @doc """
  Extracts the title from the html

  ## Examples

    iex> Explore.Parser.extract_title("<html><title>Zach's Blogspot</title></html>")
    "Zach's Blogspot"
  """
  def extract_title(%Document{ type: :text }) do
    ""
  end

  def extract_title(%Document{ content }) do
      content 
      |> Floki.find("title")
      |> format_title()
  end

  defp format_title([{_, _, [title]}]), do: title 
  defp format_title([]),                do: :none
end
