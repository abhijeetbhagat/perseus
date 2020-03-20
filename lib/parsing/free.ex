require Logger

defmodule Free do
  defstruct(
    name: :free,
    data: <<>>
  )
end

defimpl Box, for: Free do
  def parse(_, file, size) do
    <<data::binary>> = IO.binread(file, size)
    %Free{data: binary_part(data, 0, byte_size(data) - 1)}
  end
end
