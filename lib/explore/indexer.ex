defmodule Explore.Indexer do
  alias Explore.Indexer.Manager

  defdelegate index(doc),           to: Manager
  defdelegate get_index(),          to: Manager
  defdelegate get_reverse_index(),  to: Manager
end
