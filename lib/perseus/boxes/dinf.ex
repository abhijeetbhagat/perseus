require Logger

defmodule Perseus.Boxes.Dinf do
  defstruct(
    name: :dinf,
    data: nil
  )
end

alias Perseus.Boxes.Dinf

defimpl Perseus.Box, for: Dinf do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Dinf{}
  end
end
