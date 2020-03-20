require Logger

defmodule Perseus.Boxes.Pasp do
  defstruct(
    name: :pasp,
    data: nil
  )
end

alias Perseus.Boxes.Pasp

defimpl Perseus.Box, for: Pasp do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Pasp{}
  end
end
