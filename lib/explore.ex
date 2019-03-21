defmodule Explore do
  alias Explore.Parser
  alias Explore.Fetcher
  alias Explore.Indexer
  alias Explore.Frontier.Queue

  def explore([]) do
    IO.puts()
  end

  def explore(link) do
    link
    |> crawl()

    explore(Queue.pop())
  end

  @doc """
  Crawls a given link and return a document struct with the indexed document and the links found in the document
  """
  def crawl(link) do
    link
    |> fetch()
    |> parse(stem: true)
    |> index()
  end

  defdelegate fetch(doc), to: Fetcher
  defdelegate index(doc), to: Indexer
  defdelegate parse(doc, opts), to: Parser
end
