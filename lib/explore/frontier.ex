defmodule Explore.Frontier do
  alias Explore.Frontier.Queue
  alias Explore.Frontier.Gatekeeper

  defdelegate add_links(links), to: Gatekeeper
  defdelegate pop(),            to: Queue
  defdelegate empty?(),         to: Queue
end
