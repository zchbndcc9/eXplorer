defmodule Explore.Parser.Normalizer do
  
  def normalize(word, opts \\ [stem: true])
  def normalize(words, opts) when is_list(words) do
    words
    |> Enum.map(fn term -> normalize(term, opts) end)
  end

  def normalize(word, opts) do
    word
    |> String.downcase()
    |> stem(opts)
  end

  def stem(word),             do: Stemmer.stem(word)
  def stem(word, stem: true), do: Stemmer.stem(word)
  def stem(word, _),          do: word
end
