defmodule Explore.Fetcher do
  @moduledoc """
  Fetcher is a module that performs HTTP requests to retrieve html pages from the internet
  """
  def fetch(list) when is_list(list) do
    list
    |> get_pages()
    |> filter_good_pages()
  end

  def fetch(link) do
    case HTTPoison.get(link) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:no_page, "Page does not exist"}
      {_, _} -> {:error, "Some error occured"}
    end
  end

  def get_pages(list) do
    list
    |> Enum.map(fn link -> Task.async(fn -> fetch(link) end) end)
    |> Enum.map(fn task -> Task.await(task) end)
  end
  
  def filter_good_pages(list) do
    list
    |> Enum.filter(fn {status, body} -> status == :ok end)
    |> Enum.map(fn {status, body} -> body end)
  end
end
