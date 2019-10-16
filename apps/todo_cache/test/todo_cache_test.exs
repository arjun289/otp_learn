defmodule Todo.CacheTest do
  use ExUnit.Case
  doctest TodoCache
  alias Todo.Cache

  setup_all do
    Todo.Cache.start()
    :ok
  end

  test "server_process/1 returns valid names" do
    bob_pid = Todo.Cache.server_process("bobs_list")

    assert bob_pid != Todo.Cache.server_process("alice_list")
    assert bob_pid == Todo.Cache.server_process("bobs_list")
  end

  test "todo-operations" do
    alice = Todo.Cache.server_process("alice")
    Todo.Server.add_entry(alice, %{date: ~D[2018-12-19], title: "Dentist"})
    entries = Todo.Server.entries(alice, ~D[2018-12-19])

    assert [%{date: ~D[2018-12-19], title: "Dentist"}] = entries
  end
end
