defmodule Explore.Indexer.Index do
  use Agent

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add(id, doc) do
    doc = Map.delete(doc, :content)
    Agent.update(__MODULE__, fn index -> Map.put(index, id, doc) end)
  end

  def get() do
    Agent.get(__MODULE__, fn index -> index end)
  end
end
