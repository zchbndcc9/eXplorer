defmodule Explore do
  use Application

  alias Explore.Document
  alias Explore.Supervisor
  alias Explore.Parser
  alias Explore.Fetcher
  alias Explore.Indexer
  alias Explore.Frontier
  alias Explore.Indexer.Store

  defdelegate fetch(doc),       to: Fetcher
  defdelegate index(doc),       to: Indexer
  defdelegate parse(doc, opts), to: Parser

  def start(_type, _args) do
    Supervisor.start_link(name: Supervisor)
  end

  def get_stats() do
    file = File.open!("stats.txt", [:utf8, :write])

    {file, Indexer.get()}
    |> print_visited()
    |> print_outgoing()
    |> print_duplicates()
    |> print_not_found()
    |> print_figures()
    |> print_docs_indexed()

    File.close(file)
  end

  def print_visited({file, store = %Store{ index: index }}) do
    IO.puts(file, "\nFILES VISITED:\n")

    index
    |> Enum.map(fn {_key, %Document{ url: url, title: title }} -> IO.puts(file, "#{title}: https://s2.lyle.smu/~fmoore/#{url}") end)

    {file, store}
  end

  def print_outgoing({file, store = %Store{ invalids: invalids }}) do
    IO.puts(file, "\nFILES OUTGOING:\n")

    invalids
    |> Enum.map(fn url -> IO.puts(file, "#{url}") end)
    
    {file, store}
  end

  def print_duplicates({file, store = %Store{ duplicates: duplicates }}) do
    IO.puts(file, "\nDUPLICATE FILES:\n")

    duplicates
    |> Enum.map(fn url -> IO.puts(file, "https://s2.lyle.smu/~fmoore/#{url}") end)

    {file, store}
  end

  def print_not_found({file, store = %Store{ no_pages: no_pages }}) do
    IO.puts(file, "\nBROKEN LINKS:\n")

    no_pages
    |> Enum.map(fn url -> IO.puts(file, "https://s2.lyle.smu/~fmoore/#{url}") end)

    {file, store}
  end
  
  def print_figures({file, store = %Store{ figures: figures }}) do
    IO.puts(file, "\nFIGURES:\n")

    figures
    |> Enum.map(fn url -> IO.puts(file, "https://s2.lyle.smu/~fmoore/#{url}") end)

    {file, store}
  end

  def print_docs_indexed({file, store = %Store{ index: index }}) do
    IO.puts(file, "\nNUM DOCS INDEXED: #{Enum.count(index)}")

    {file, store}
  end

  def print_words_indexed({file, store = %Store{ reverse_index: reverse_index }}) do
    IO.puts(file, "\nNUM WORDS INDEXED: #{Enum.count(reverse_index)}")
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
    |> parse(stem: true)
    |> index()
  end
end
