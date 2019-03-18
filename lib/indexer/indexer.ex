defmodule Explore.Indexer do

  def some_method(opts \\ [])

  def some_method(opts) when opts == [] do
    {:ok}
  end

  def some_method(opts) do
    {:ok, [opts]}
  end

  defp private_method do
    {:ok}
  end
end
