require Logger
defmodule Pasp do
  defstruct(
    name: :pasp,
    data: nil
  )
end

defimpl Box, for: Pasp do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Pasp{}
  end
end
