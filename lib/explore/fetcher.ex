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
    |> determine_valid_path()
    |> determine_crawlable()
    |> retrieve_page()
    |> determine_type()
    |> generate_id()
    |> check_duplicate()
    |> store_id()
  end

  def determine_valid_path(doc = %Document{ url: link}) do
    uri = URI.parse(link)
    status = 
      case uri.host do
        nil -> :ok
        _   -> :invalid
      end

    %Document{ doc | status: status }
  end 

  def determine_crawlable(doc = %Document{ status: :ok, url: url }) do
    name = Gollum.Cache
    host = "https://s2.smu.edu/~fmoore" 
    status = 
      case Gollum.Cache.fetch(host, name: name) do
        {:error, _} -> :crawlable
        :ok -> 
          host
          |> Gollum.Cache.get(name: name)
          |> Gollum.Host.crawlable?("Explorer", url)
      end

    %Document{ doc | status: status }
  end

  def determine_crawlable(doc) do
    doc
  end

  def retrieve_page(doc = %Document{ status: :crawlable, url: url }) do
    path = "https://s2.smu.edu/~fmoore" <> "/" <> url
    
    { status, body, type } =
      case HTTPoison.get(path) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body, headers: type}} -> {:ok, body, type}
        {:ok, %HTTPoison.Response{status_code: 404}} -> {:no_page, nil, nil }
        {_, _} -> {:error, nil, nil }
      end

    %Document{ doc | status: status, content: body, type: type }
  end

  def retrieve_page(doc) do
    doc
  end

  def determine_type(doc = %Document{ status: :ok, type: type }) do
    new_type =
      type
      |> Enum.find(fn {key, _value} -> key == "Content-Type" end)
      |> elem(1)

    %Document{ doc | type: new_type }
  end

  def determine_type(doc) do
    doc
  end

  def generate_id(doc = %Document{ status: :ok, content: content }) do
    hash = Base.encode16(:crypto.hash(:sha512, content))

    %Document{ doc | id: hash }
  end

  def generate_id(doc) do
    %Document{ doc | id: nil }
  end

  def check_duplicate(doc) do
    doc
  end

  def store_id(doc) do
    doc
  end
end
