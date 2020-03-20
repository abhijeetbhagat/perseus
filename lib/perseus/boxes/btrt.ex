require Logger

defmodule Perseus.Boxes.Btrt do
  defstruct(
    name: :btrt,
    buffer_size_db: 0,
    max_bitrate: 0,
    avg_bitrate: 0
  )
end

alias Perseus.Boxes.Btrt

defimpl Perseus.Box, for: Btrt do
  def parse(_, file, size) do
    <<
      buffer_size_db::integer-32,
      max_bitrate::integer-32,
      avg_bitrate::integer-32
    >> = IO.binread(file, size)

    %Btrt{
      buffer_size_db: buffer_size_db,
      max_bitrate: max_bitrate,
      avg_bitrate: avg_bitrate
    }
  end
end
