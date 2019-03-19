defmodule Explore.Parser do

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
  def extract(html, opts \\ [stem: true]) do
    links_task = Task.async(fn -> extract_unique_urls(html) end)
    indexes_task = Task.async(fn -> extract_indexes(html, opts) end)
    title_task = Task.async(fn -> extract_title(html) end)

    %{
      indexes: Task.await(indexes_task),
      links: Task.await(links_task),
      title: Task.await(title_task)
    }
  end
  
  @doc """
  Will extract a list of all urls within html and return the list in alphebetical order

  ## Examples
    
    iex> Explore.Parser.extract_urls("<body><a href='google.com'><div><a href='facebook.com'></div></body>")
    ["facebook.com", "google.com"] 
  """
  def extract_urls(html) do
    html
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
  def extract_unique_urls(html) do
    html
    |> extract_urls()
    |> Enum.uniq()
  end

  @doc """
  Extracts all indexes with html and returns the list of stemmed words in alphebetical order

  By default the function will stem the words, but a `stem` flag can be supplied in order to prevent the words from being stemmed
  """
  def extract_indexes(html, opts \\ [stem: true]) do
    html
    |> filter_html(["noscript", "style"]) 
    |> Floki.text(sep: " ")
    |> String.split(" ")
    |> normalize_terms(opts)
    |> Enum.sort()
  end
  
  def normalize_terms(words, opts \\ [stem: true]) do
    words
    |> rid_punctuation()
    |> Enum.map(fn term-> String.downcase(term) end)
    |> stem_words(opts)
    |> Enum.uniq()
  end

  def rid_punctuation(words) do
    words
    |> Enum.map(fn word -> Regex.run(~r/[\w\d]+/, word) end)
    |> Enum.reject(fn word -> word === nil end)
    |> List.flatten
  end

  def stem_words(html, stem: true), do: Stemmer.stem(html)
  def stem_words(html, _),          do: html

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
  def extract_title(html) do
      html
      |> Floki.find("title")
      |> format_title()
  end

  defp format_title([{_, _, [title]}]), do: title 
  defp format_title([]),                do: :none
end
