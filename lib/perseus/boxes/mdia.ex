require Logger

defmodule Perseus.Boxes.Mdia do
  defstruct(
    name: :mdia,
    mdhd: nil,
    hdlr: nil,
    minf: nil
  )
end

alias Perseus.Boxes.Mdia

defimpl Perseus.Box, for: Mdia do
  def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, mdia)
      when cnt < size do
    Logger.debug("cnt: #{cnt}, size: #{size}, length: #{length}")

    box =
      case atom_type do
        "mdhd" ->
          %Perseus.Boxes.Mdhd{}

        "hdlr" ->
          %Perseus.Boxes.Hdlr{}

        "minf" ->
          %Perseus.Boxes.Minf{}

        type ->
          Logger.debug("Invalid atom type #{type} found during parsing")
          throw(atom_type)
      end

    box = Perseus.Box.parse(box, file, length - 8)
    Logger.debug(inspect(box))

    loop(IO.binread(file, 8), file, cnt + length, size, mdia |> Map.put(box.name, box))
  end

  def loop(:eof, _, _, _, mdia) do
    mdia
  end

  def loop(<<_::integer-32, _::binary-4>>, file, _, _, mdia) do
    # because the current pos is past next atom's length and name
    :file.position(file, {:cur, -8})
    mdia
  end

  def loop({:error, reason}, _, _, _, _) do
    Logger.debug("Error occurred while reading file #{reason}")
  end

  def parse(mdia, file, size) do
    loop(IO.binread(file, 8), file, 8, size, mdia)
  end
end
