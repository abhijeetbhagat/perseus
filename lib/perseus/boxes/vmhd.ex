require Logger

defmodule Perseus.Boxes.Vmhd do
  defstruct(
    name: :vmhd,
    graphics_mode: 0,
    opcolor: []
  )
end

alias Perseus.Boxes.Vmhd

defimpl Perseus.Box, for: Vmhd do
  def parse(_, file, size) do
    <<
      _::binary-size(4),
      graphics_mode::integer-16,
      opcolor1::integer-16,
      opcolor2::integer-16,
      opcolor3::integer-16
    >> = IO.binread(file, size)

    %Vmhd{
      graphics_mode: graphics_mode,
      opcolor: [opcolor1, opcolor2, opcolor3]
    }
  end
end
