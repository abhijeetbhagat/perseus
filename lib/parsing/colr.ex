require Logger
defmodule Colr do
  defstruct(
    name: :colr,
    data: nil
  )
end

defimpl Box, for: Colr do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Colr{}
  end
end
