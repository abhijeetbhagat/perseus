defmodule PerseusTest do
  use ExUnit.Case
  doctest Perseus

  test "greets the world" do
    assert Perseus.hello() == :world
  end
end
