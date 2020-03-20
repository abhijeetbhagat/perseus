defmodule Perseus.Boxes.Unknown do
  @moduledoc """
  The `Perseus.Boxes.Unknown` represents a box
  which is not implemented in this library yet.

  This means the library should not fail when
  an unknown box is encountered.
  """
  defstruct(name: nil, data: nil)
end

alias Perseus.Boxes.Unknown

defimpl Perseus.Box, for: Unknown do
  def parse(box, file, length) do
    box |> Map.put(:data, IO.binread(file, length))
  end
end
