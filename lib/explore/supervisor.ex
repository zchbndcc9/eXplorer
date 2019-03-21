defmodule Explore.Supervisor do
  use Supervisor
  alias Explore.Indexer.Store
  alias Explore.Frontier.Queue

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
    children = [
      Store,
      Queue
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
