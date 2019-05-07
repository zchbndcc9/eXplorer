defmodule Explore do
  use Application

  alias Explore.Document
  alias Explore.Supervisor
  alias Explore.Parser
  alias Explore.Fetcher
  alias Explore.Indexer
  alias Explore.Frontier
  alias Explore.Indexer.Store
  alias Explore.Stats

  defdelegate fetch(doc),       to: Fetcher
  defdelegate index(doc),       to: Indexer
  defdelegate parse(doc, opts), to: Parser
  defdelegate get_stats(),   to: Stats

  def start(_type, _args) do
    Supervisor.start_link(name: Supervisor)
  end

  def explore(link) do
    link
    |> crawl()
    |> Frontier.add_links()

    case Frontier.empty?() do
      true -> get_stats() 
      false -> explore(Frontier.pop())
    end
  end

  @doc """
  Crawls a given link and return a document struct with the indexed document and the links found in the document
  """
  def crawl(link) do
    link
    |> fetch()
    |> parse([stem: false])
    |> index()
  end
end
