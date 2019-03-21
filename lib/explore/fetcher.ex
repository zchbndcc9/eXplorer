defmodule Explore.Fetcher do
  alias Explore.Document

  @moduledoc """
  Fetcher is a module that performs HTTP requests to retrieve html pages from the internet
  """
  def get_docs(list) when is_list(list) do
    list
    |> Enum.map(fn link -> get_doc(link) end)
  end

  def get_doc(link) do
    %Document{ url: link }
    |> retrieve_robot()
    |> retrieve_page()
    |> determine_type()
    |> generate_id()
    |> check_duplicate()
    |> store_id()
  end

  def retrieve_robot(doc = %Document{ url: url }) do
    status = Gollum.crawlable?("Explorer", url)

    %Document{ doc | status: status }
  end

  def retrieve_page(doc = %Document{ status: :crawlable, url: url }) do
    { status, body, type } =
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: type}} -> {:ok, body, type}
        {:ok, %HTTPoison.Response{status_code: 404}} -> {:no_page, "Page does not exist", "none"}
        {_, _} -> {:error, "Some error occured", "none"}
      end

    %Document{ doc | status: status, content: body, type: type }
  end

  def retrieve_page(doc) do
    doc
  end

  def determine_type(doc = %Document{ type: "none" }) do
    doc
  end

  def determine_type(doc = %Document{ type: type }) do
    new_type =
      type
      |> Enum.find(fn {key, value} -> key == "Content-Type" end)
      |> elem(1)

    %Document{ doc | type: new_type }
  end
  def generate_id(doc = %Document{ status: :ok, content: content }) do
    hash = Base.encode16(:crypto.hash(:sha512, content))

    %Document{ doc | id: hash }
  end

  def generate_id(doc) do
    %Document{ doc | id: :none }
  end

  def check_duplicate(doc) do
    doc
  end

  def store_id(doc) do
    doc
  end
end
