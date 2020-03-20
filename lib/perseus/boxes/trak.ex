require Logger

defmodule Perseus.Boxes.Trak do
  defstruct(
    name: :trak,
    tkhd: nil,
    edts: nil,
    mdia: nil
  )
end

alias Perseus.Boxes.Trak

defimpl Perseus.Box, for: Trak do
  def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, trak)
      when cnt < size do
    Logger.debug(
      "tkhd: cnt: #{cnt}, size: #{size}, length: #{length} pos: #{
        elem(:file.position(file, :cur), 1)
      }"
    )

    box =
      case atom_type do
        "tkhd" ->
          %Perseus.Boxes.Tkhd{}

        "edts" ->
          %Perseus.Boxes.Edts{}

        "mdia" ->
          %Perseus.Boxes.Mdia{}

        "udta" ->
          %Perseus.Boxes.Udta{}

        type ->
          Logger.debug("Invalid atom type #{type} found during parsing")
          throw(atom_type)
      end

    box = Perseus.Box.parse(box, file, length - 8)
    Logger.debug(inspect(box))

    loop(IO.binread(file, 8), file, cnt + length, size, trak |> Map.put(box.name, box))
  end

  def loop(:eof, _, _, _, trak) do
    trak
  end

  def loop(<<_::integer-32, _::binary-4>>, file, _, _, trak) do
    # because the current pos is past next atom's length and name
    :file.position(file, {:cur, -8})
    trak
  end

  def loop({:error, reason}, _, _, _, _) do
    Logger.debug("Error occurred while reading file #{reason}")
  end

  def parse(trak, file, size) do
    loop(IO.binread(file, 8), file, 0, size, trak)
  end
end
