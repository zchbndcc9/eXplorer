defmodule Explore.Indexer.ReverseIndex do
  use Agent
  
  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def add(document, term) do
    Agent.update(__MODULE__, fn rindex -> Map.update(rindex, term, [document], &([term | &1])) end)
  end

  def get() do
    Agent.get(__MODULE__, fn rindex -> rindex end)
  end
end
