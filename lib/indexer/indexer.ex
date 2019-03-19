defmodule Explore.Indexer do
  def index(list) when is_list(list) do
    list        
  end

  def index(item) do
    item
  end
end
