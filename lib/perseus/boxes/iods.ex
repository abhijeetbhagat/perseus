require Logger

defmodule Perseus.Boxes.Iods do
  defstruct(
    name: :iods,
    data: nil
  )
end

alias Perseus.Boxes.Iods

defimpl Perseus.Box, for: Iods do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Iods{}
  end
end
