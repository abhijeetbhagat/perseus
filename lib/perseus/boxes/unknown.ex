defmodule Perseus.Boxes.Unknown do
  defstruct(name: nil, data: nil)
end

alias Perseus.Boxes.Unknown

defimpl Perseus.Box, for: Unknown do
  def parse(box, file, length) do
    box |> Map.put(:data, IO.binread(file, length))
  end
end
