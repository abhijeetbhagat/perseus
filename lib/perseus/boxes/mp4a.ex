require Logger

defmodule Perseus.Boxes.Mp4a do
  defstruct(
    name: :mp4a,
    data: nil
  )
end

alias Perseus.Boxes.Mp4a

defimpl Perseus.Box, for: Mp4a do
  def parse(_, file, size) do
    %Mp4a{data: IO.binread(file, size)}
  end
end
