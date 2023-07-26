defmodule ExBrasilApiTest do
  use ExUnit.Case
  doctest ExBrasilApi

  test "greets the world" do
    assert ExBrasilApi.hello() == :world
  end
end
