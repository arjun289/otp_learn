defmodule ServerProcessTest do
  use ExUnit.Case
  doctest ServerProcess

  test "greets the world" do
    assert ServerProcess.hello() == :world
  end
end
