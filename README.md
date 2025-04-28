# Docker

## Clean if necessary
```bash
docker stop d3bot
docker container rm d3bot
docker image rm d3bot
```

## Build and start
```bash
docker build -t d3bot .
docker create -it -v "$PWD:/home/app/project" --name d3bot d3bot
docker start -ia d3bot
```

## Set up tunnel
```bash
source ./create_envs.sh
docker run -it -e NGROK_AUTHTOKEN=$NGROK_AUTHTOKEN ngrok/ngrok:latest http --url=quiet-anteater-hideously.ngrok-free.app host.docker.internal:5000
```

## Inspect container
```bash
docker exec -it d3bot /bin/bash
```

# D3bot

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `d3bot` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:d3bot, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/d3bot>.

