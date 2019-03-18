defmodule Parser do

  @doc """
  Will extract a list of all urls within html

  iex> Explore.Parser('<body><a href="google.com"><div><a href="facebook.com"</div></body>')
  ["google.com", "facebook.com"] 
  """
  def extract_urls(html) do
    html
    |> Floki.find("a")
    |> Floki.attribute("href")
  end
end
