defmodule MagoTest do
  use ExUnit.Case
  doctest Mago

  test "greets the world" do
    assert Mago.hello() == :world
  end
end
