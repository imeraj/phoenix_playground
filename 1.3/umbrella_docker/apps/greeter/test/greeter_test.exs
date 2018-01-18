defmodule GreeterTest do
  use ExUnit.Case
  doctest Greeter

  test "greets the world" do
    assert Greeter.hello("Fernando") == "Hello Fernando"
  end
end
