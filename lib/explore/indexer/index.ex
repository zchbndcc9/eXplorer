defmodule Explore.Indexer.Index do
  use Agent

  def start_link(_) do
    Agent.start_link(__MODULE__, fn -> %{} end, name: __MODULE__)
  end

  def add(document, terms) do
    Agent.update(__MODULE__, fn index -> Map.put(index, document, terms) end)
  end

  def get() do
    Agent.get(__MODULE__, fn index -> index end)
  end
end
