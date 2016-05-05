defmodule Saxophone.GenServerRestarterTest do
  use ExUnit.Case
  alias Saxophone.GenServerRestarterTest.AGenServer

  defmodule AGenServer do
    use GenServer

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
    {:ok, pid} = Saxophone.GenServerRestarter.start_link(:timer.seconds(0),
                                                         [],
                                                         AGenServer,
                                                         [:a, :b], name: :a_gen_server)
    :timer.sleep(1)
    {:ok, %{pid: pid}}
  end

  test "starts the GenServer with the args" do
    assert Process.whereis(:a_gen_server)
    assert AGenServer.get_status == [:a, :b]
  end

  test "kill and restart" do
    original_pid = Process.whereis(:a_gen_server)

    Process.exit(Process.whereis(:a_gen_server), :kill)
    :timer.sleep(100)


    refute original_pid == Process.whereis(:a_gen_server)
    assert Process.whereis(:a_gen_server)
  end
end
