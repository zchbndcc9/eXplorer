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
  """
  def extract_unique_urls(html) do
    html
    |> extract_urls()
    |> Enum.uniq()
  end
end
