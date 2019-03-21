defmodule Explore.Parser.Cleaner do
  def clean(terms) when is_list(terms) do
    terms
    |> split_special_terms()
    |> Enum.map(fn term -> clean(term) end)
    |> Enum.filter(fn term -> is_valid?(term) end)
  end

  def clean(term) do
    term
    |> String.trim()
    |> rid_punctuation()
  end

  def split_special_terms(terms) do
    terms
    |> Enum.map(fn term -> String.split(term, [".", "-", "/"]) end)
    |> List.flatten()
  end

  def rid_punctuation(term) do
    Regex.replace(~r/[^\w\s]/, term, "")
  end

  def is_valid?(term) do
    !Regex.match?(~r/^\d/, term) && term != ""
  end
end
