defmodule ExServerTimings.Plug do
  require Logger
  alias Plug.Conn
  @behaviour Plug

  def init(_opts) do
    :ok
  end

  def call(conn, :ok) do
    start = System.monotonic_time()

    Conn.register_before_send(conn, fn conn ->
      stop = System.monotonic_time()
      diff = System.convert_time_unit(stop - start, :native, :milliseconds)

      Conn.put_resp_header(conn, "server-timing", "cpu;dur=#{diff};desc=\"Server Time\"")
    end)
  end
end
