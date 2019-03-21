defmodule Explore.Supervisor do
  use Supervisor
  alias Explore.Indexer.Index
  alias Explore.Indexer.ReverseIndex

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Index,
      ReverseIndex
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
