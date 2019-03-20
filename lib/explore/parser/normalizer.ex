defmodule Explore.Parser.Normalizer do
  def normalize(words, opts \\ [stem: true]) when is_list(words) do
    words
    |> Enum.map(fn term -> normalize(term, opts) end)
    |> Enum.reject(fn word -> word === nil end)
    |> List.flatten()
    |> Enum.uniq()
  end

  def normalize(word, opts \\ [stem: true]) do
    word
    |> rid_punctuation()
    |> String.downcase()
    |> stem(opts)
  end

  def rid_punctuation(word) do
    [new_word] = Regex.run(~r/[\w\d]+/, word)

    new_word
  end

  def stem(word),             do: Stemmer.stem(word)
  def stem(word, stem: true), do: Stemmer.stem(word)
  def stem(word, _),          do: word
end
