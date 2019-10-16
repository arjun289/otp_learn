defmodule Todo.Server do
  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(todo_server, entry) do
    GenServer.cast(todo_server, {:add_entry, entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end

  ######################### Server Calls ###############

  @impl GenServer
  def init(_args) do
    {:ok, Todo.List.new()}
  end

  @impl GenServer
  def handle_call({:entries, date}, _from, _state = todo_list) do
    {:reply, Todo.List.entries(todo_list, date), todo_list}
  end

  @impl GenServer
  def handle_cast({:add_entry, entry}, _state=todo_list) do
    {:noreply, Todo.List.add_entry(todo_list, entry)}
  end
end
