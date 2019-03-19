defmodule Explore.Parser do

  @doc """
  Will extract a list of all urls within html and return the list in alphebetical order

  iex> Explore.Parser.extract_urls('<body><a href="google.com"><div><a href="facebook.com"</div></body>')
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

  iex> Explore.Parser.extract_unique_urls("<body><a href=\"google.com\"><a href=\"google.com\"><body>")
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
    |> Floki.text(sep: " ")
    |> String.split(" ")
    |> Enum.map(fn term -> String.downcase(term) end)
    |> stem_words(opts)
    |> Enum.uniq()
    |> Enum.sort()
  end

  def stem_words(html, stem: true), do: Stemmer.stem(html)
  def stem_words(html, _),          do: html
end
