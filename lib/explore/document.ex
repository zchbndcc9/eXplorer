defmodule Explore.Document do
  defstruct(
    id: "",
    url: "",
    type: :none,
    title: "",
    content: "",
    terms: [],
    links: [],
    status: :initializing,
  )
end
