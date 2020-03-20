require Logger

defmodule Perseus do
  @moduledoc """
  Perseus is an ISO-BMFF file parsing library.
  """

  @spec get_meta(binary) :: :ok
  @doc """
  returns a map containing box names and objects

  ## Examples

      iex> Perseus.get_meta(~S(C:\Users\abhagat\code\mp4box\test\output_squirrel.mp4))
      %{
        free: %Perseus.Boxes.Free{
          data: "IsoMedia File Produced with GPAC 0.8.0-rev9-g6e4af05b-master",
          name: :free
        },
        ftyp: %Perseus.Boxes.FTyp{
          compatible_brands: ["isom", "avc1"],
          major_brand: "isom",
          minor_version: 1,
          name: :ftyp
        },
        ...
      }

  """
  def get_meta(path) do
    {time, result} = :timer.tc(fn -> Parser.parse(path) end)
    Logger.debug("parse time: #{time} µs")
    result
  end
end
