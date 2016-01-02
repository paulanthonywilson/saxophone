if :prod != Mix.env do

  defmodule Ethernet do
    use GenServer

    @moduledoc """
    Does nothing. Stands in for https://github.com/cellulose/ethernet
    during development. Partial implementation for now.
    """

    def start_link do
      GenServer.start_link(__MODULE__, [], [name: :dummy_ethernet])
    end

    def init(_args) do
      {:ok, []}
    end

  end

  defmodule Gpio do
    use GenServer

    @moduledoc """
    Stand in for Elixir Ale's Gpio in development mode
    """

    defmodule State do
      defstruct pin: 0, direction: nil, pin_state: 0
    end

    def start_link(pin, direction, opts \\ []) do
      GenServer.start_link(__MODULE__, {pin, direction}, opts)
    end

    @doc """
    Just change the value of the 'pin' to the value. Can be read by #read/2
    """
    def write(pid, value) do
      GenServer.call(pid, {:write, value})
    end

    @doc """
    Read the value of the pin. Can be set by #write/1
    """
    def read(pid) do
      GenServer.call(pid, :read)
    end

    # Genserver
    def init({pin, direction}) do
      state = %State{pin: pin, direction: direction, pin_state: 0}
      {:ok, state}
    end

    def handle_call({:write, value}, _from, state) do
      new_state = state |> Map.put(:pin_state, value)
      {:reply, :ok, new_state} #todo - what should the actual reply be?
    end

    def handle_call(:read, _from, state) do
      {:reply, state.pin_state, state}
    end
  end
end
