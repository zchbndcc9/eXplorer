defmodule Explore do
  alias Explore
  alias Explore.Parser
  alias Explore.Fetcher

  def crawl(link) do
    link
    |> Fetcher.fetch()
    |> parse(stem: true)
  end

  def parse({ :ok, page }, opts) do
    { :ok, Parser.extract(page, opts) }
  end
  
  def parse({ status, reason }, _) do
    { status, reason }
  end
end
