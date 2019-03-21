defmodule Explore.Indexer.Manager do
  alias Explore.Document
  alias Explore.Indexer.Index
  alias Explore.Indexer.ReverseIndex

  def index(doc = %Document{ status: :duplicate }) do
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
    Index.add(id, doc)    

    doc
  end

  def add_to_reverse_index(doc = %Document{ id: id, terms: terms }) do
    terms
    |> Map.keys()
    |> Enum.map(fn key -> ReverseIndex.add(id, key) end)

    doc
  end

  def get_index() do
    Index.get()
  end

  def get_reverse_index() do
    ReverseIndex.get()
  end
end
