defmodule Saxophone.GenServerRestarterTest do
  use ExUnit.Case
  alias Saxophone.GenServerRestarterTest.AGenServer

  defmodule AGenServer do
    use GenServer

    def start_link(arg1, arg2) do
      GenServer.start_link(__MODULE__, {arg1, arg2}, name: :a_gen_server)
    end

    def get_status do
      :a_gen_server |> GenServer.call(:get_status)
    end

    def init(status) do
      {:ok, status}
    end

    def handle_call(:get_status, _from, status) do
      {:reply, status, status}
    end
  end

  setup do
    {:ok, _pid} = Saxophone.GenServerRestarter.start_link(AGenServer,
                                                          :start_link,
                                                          [:a, :b],
                                                          0)
    :timer.sleep(1)
    :ok
  end

  test "starts the GenServer with the args" do
    assert Process.whereis(:a_gen_server)
    assert AGenServer.get_status == {:a, :b}
  end

  test "kill and restart" do
    original_pid = Process.whereis(:a_gen_server)

    Process.exit(Process.whereis(:a_gen_server), :kill)
    :timer.sleep(100)


    refute original_pid == Process.whereis(:a_gen_server)
    assert Process.whereis(:a_gen_server)
  end
end
