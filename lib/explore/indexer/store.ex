defmodule Explore.Indexer.Store do
  use Agent
  alias Explore.Indexer.Store
  
  defstruct(
    reverse_index: %{},
    index: %{},
    duplicates: [],
    figures: [],
    no_pages: [],
    invalids: [],
    uncrawlables: []
  )

  def start_link(_) do
    Agent.start_link(fn -> %Store{} end, name: __MODULE__)
  end
  
  def add_to_uncrawables(value) do
    Agent.update(__MODULE__, fn store -> update_uncrawables(store, value) end)
  end

  def add_to_invalids(value) do
    Agent.update(__MODULE__, fn store -> update_invalids(store, value) end)
  end

  def add_to_reverse_index(id, value) do
    Agent.update(__MODULE__, fn store -> update_reverse_index(store, id, value) end)
  end

  def add_to_index(id, value) do
    Agent.update(__MODULE__, fn store -> update_index(store, id, value) end)
  end

  def add_to_figures(value) do
    Agent.update(__MODULE__, fn store -> update_figures(store, value) end)
  end

  def add_to_duplicates(value) do
    Agent.update(__MODULE__, fn store -> update_duplicates(store, value) end)
  end

  def add_to_no_pages(value) do
    Agent.update(__MODULE__, fn store -> update_no_pages(store, value) end)
  end

  def get() do
    Agent.get(__MODULE__, fn store -> store end)
  end

  def update_index(store = %Store{ index: index }, id, value) do
    index = Map.put(index, id, value)
    %Store{ store | index: index }
  end
  
  def update_reverse_index(store = %Store{ reverse_index: reverse_index }, id, value) do
    reverse_index = Map.update(reverse_index, id, [value], &([value | &1]))
    %Store{ store | reverse_index: reverse_index}
  end
  
  def update_uncrawables(store = %Store{ uncrawlables: uncrawlables }, value) do
    %Store{ store | uncrawlables: [value | uncrawlables] }
  end

  def update_invalids(store = %Store{ invalids: invalids }, value) do
    %Store{ store | invalids: [value | invalids] }
  end
  
  def update_figures(store = %Store{ figures: figures }, value) do
    %Store{ store | figures: [value | figures] }
  end

  def update_duplicates(store = %Store{ duplicates: duplicates }, value) do
    %Store{ store | duplicates: [value | duplicates] }
  end
  
  def update_no_pages(store = %Store{ no_pages: no_pages }, value) do
    %Store{ store | no_pages: [value | no_pages] }
  end
end
