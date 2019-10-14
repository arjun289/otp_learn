defmodule Server.GenericServer do
  @moduledoc """
  Implements a generic server.
  """
  @callback init() :: state :: any
  @callback handle_call(request :: tuple, state :: any) ::
    {response :: any, new_state :: any}
  @callback handle_cast(request :: tuple, state :: any)
    :: {new_state :: any}

  def start(callback_module) do
    spawn(fn ->
      initial_state = callback_module.init()
      loop(callback_module, initial_state)
    end)

  end

  defp loop(callback_module, state) do
    new_state =
      receive do
        {:call, from, request} ->
          {result, state} = callback_module.handle_call(request, state)
          send(from, {:result, result})
          state
      end

    loop(callback_module, new_state)
  end

  def call(server_pid, request) do
    send(server_pid, {:call, self(), request})

    receive do
      {:result, result} ->
        result                         ########### returns the result of the operation
      _ ->
        IO.puts("unrecognized output!") ######### protects mail box from flooding
    end
  end

end
