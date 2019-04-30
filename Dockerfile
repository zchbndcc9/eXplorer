FROM elixir:1.8

RUN mkdir crawler 
WORKDIR crawler
COPY . .
RUN mix local.hex --force && mix deps.get && mix compile

CMD ["iex", "-S", "mix"]
