defmodule Explore.Indexer.ReverseIndex do
  def start_link(_) do
    Agent.start_link(__MODULE__, fn -> %{} end)
  end

  def add(term, document) do
    Agent.update(__MODULE__, fn rindex -> Map.update(term, [document], &([term | &1])) end)
  end

  def get() do
    Agent.get(__MODULE__, fn rindex -> rindex end)
  end
end
