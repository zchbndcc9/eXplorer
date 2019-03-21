defmodule Explore.Indexer do
  alias Explore.Indexer.Manager
  alias Explore.Indexer.Store

  defdelegate index(doc),           to: Manager
  defdelegate get(),                to: Store
end
