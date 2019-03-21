defmodule Explore.Frontier.Gatekeeper do
  alias Explore.Document
  alias Explore.Frontier.Queue

  def add_links(%Document{ links: links }) do
    links
    |> Enum.map(fn link -> Queue.push(link) end)
  end
end
