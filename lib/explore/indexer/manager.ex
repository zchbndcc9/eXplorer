defmodule Explore.Indexer.Manager do
  alias Explore.Indexer.Store
  alias Explore.Document
  
  def index(doc = %Document{ status: :uncrawlable, url: url }) do
    Store.add_to_uncrawables(url)

    doc
  end

  def index(doc = %Document{ status: :invalid, url: url }) do
    Store.add_to_invalids(url)

    doc
  end

  def index(doc = %Document{ status: :no_page, url: url }) do
    Store.add_to_no_pages(url)

    doc
  end

  def index(doc = %Document{ status: :duplicate, url: url }) do
    Store.add_to_duplicates(url)

    doc
  end

  def index(doc = %Document{ type: :figure, url: url }) do
    Store.add_to_figures(url)

    doc
  end

  def index(doc = %Document{ status: :ok }) do
    doc =
      doc
      |> init_tf_map()
      |> add_to_index()
      |> add_to_reverse_index()

    doc
  end

  def index(doc) do
    doc
    |> add_to_index()

    doc
  end

  def init_tf_map(doc = %Document{ terms: terms }) do
    terms =
      terms
      |> Enum.reduce(%{}, fn(term, acc) -> add_term_freq(term, acc) end)

    %Document{ doc | terms: terms }
  end

  def add_term_freq(term, acc) do
    Map.update(acc, term, 1, &(&1 + 1))
  end

  def add_to_index(doc = %Document{ id: id }) do
    doc = Map.delete(doc, :content)
    Store.add_to_index(id, doc)    

    doc
  end

  def add_to_reverse_index(doc = %Document{ id: id, terms: terms }) do
    terms
    |> Map.keys()
    |> Enum.map(fn key -> Store.add_to_reverse_index(key, id) end)

    doc
  end
end
