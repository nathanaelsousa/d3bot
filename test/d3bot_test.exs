defmodule D3botTest do
  use ExUnit.Case
  doctest D3bot

  test "greets the world" do
    assert D3bot.hello() == :world
  end
end
