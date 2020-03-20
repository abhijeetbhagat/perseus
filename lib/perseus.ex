require Logger

defmodule Perseus do
  @moduledoc """
  Documentation for `Perseus`.
  """

  @spec get_meta(binary) :: :ok
  @doc """
  Hello world.

  ## Examples

      iex> Perseus.get_meta(~S(C:\Users\abhagat\code\mp4box\test\output_squirrel.mp4))
      :world

  """
  def get_meta(path) do
    {time, result} = :timer.tc(fn -> Parser.parse(path) end)
    Logger.debug("parse time: #{time} µs")
    result
  end
end
