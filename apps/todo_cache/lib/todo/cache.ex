defmodule Todo.Cache do
  @moduledoc """
  Cache to hold pids of TodoServers

  Creates a mapping between todo_server names and their
  pids to make interaction easy.
  """

  use GenServer

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(todo_list_name) do
    GenServer.call(__MODULE__, {:server_pid, todo_list_name})
  end

  ################### Server Calls ##################

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:server_pid, todo_list_name}, _from, _state=todo_servers) do
    {pid, todo_servers} =
      todo_servers
      |> Map.fetch(todo_list_name)
      |> get_server_pid(todo_list_name, todo_servers)

    {:reply, pid, todo_servers}
  end

  ################# private functions ################

  defp get_server_pid({:ok, pid}, _todo_list_name, todo_servers) do
    {pid, todo_servers}
  end

  defp get_server_pid(:error, todo_list_name, todo_servers) do
    {:ok, pid} = Todo.Server.start()
    todo_servers = Map.put(todo_servers, todo_list_name, pid)
    {pid, todo_servers}
  end
end
