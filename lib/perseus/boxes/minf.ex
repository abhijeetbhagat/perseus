require Logger

defmodule Perseus.Boxes.Minf do
  defstruct(
    name: :minf,
    vmhd: nil,
    dinf: nil,
    stbl: nil
  )
end

alias Perseus.Boxes.Minf

defimpl Perseus.Box, for: Minf do
  def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, minf)
      when cnt < size do
    Logger.debug("cnt: #{cnt}, size: #{size}, length: #{length}")

    box =
      case atom_type do
        "vmhd" ->
          %Perseus.Boxes.Vmhd{}

        "dinf" ->
          %Perseus.Boxes.Dinf{}

        "stbl" ->
          %Perseus.Boxes.Stbl{}

        type ->
          %Perseus.Boxes.Unknown{name: String.to_atom(type)}

      end

    box = Perseus.Box.parse(box, file, length - 8)
    Logger.debug(inspect(box))

    loop(IO.binread(file, 8), file, cnt + length, size, minf |> Map.put(box.name, box))
  end

  def loop(:eof, _, _, _, minf) do
    minf
  end

  def loop(<<_::integer-32, _::binary-4>>, file, _, _, minf) do
    # because the current pos is past next atom's length and name
    :file.position(file, {:cur, -8})
    minf
  end

  def loop({:error, reason}, _, _, _, _) do
    Logger.debug("Error occurred while reading file #{reason}")
  end

  def parse(minf, file, size) do
    loop(IO.binread(file, 8), file, 8, size, minf)
  end
end
