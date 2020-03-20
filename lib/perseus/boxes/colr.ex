require Logger

defmodule Perseus.Boxes.Colr do
  defstruct(
    name: :colr,
    data: nil
  )
end

alias Perseus.Boxes.Colr

defimpl Perseus.Box, for: Colr do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Colr{}
  end
end
