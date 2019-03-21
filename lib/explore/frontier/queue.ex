defmodule Explore.Frontier.Queue do
  def start_link(_) do
    Agent.start_link(__MODULE__, fn -> [] end, name: __MODULE__)
  end

  def push(link) do
    Agent.update(__MODULE__, fn queue -> queue ++ [link] end)
  end

  def pop() do
    Agent.get_and_update(__MODULE__, fn [link | queue]-> {link, queue} end)
  end

  def empty?() do
    Agent.get(__MODULE__, fn queue -> Enum.empty?(queue) end)
  end
end
