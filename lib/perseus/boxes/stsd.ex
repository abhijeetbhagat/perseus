require Logger

defmodule Perseus.Boxes.Stsd do
  defstruct(
    name: :stsd,
    entry_count: 0,
    avc1: nil,
    mp4a: nil
  )
end

alias Perseus.Boxes.Stsd

defimpl Perseus.Box, for: Stsd do
  def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, stsd)
      when cnt < size do
    Logger.debug("stsd: cnt: #{cnt}, size: #{size}, length: #{length}")

    box =
      case atom_type do
        "avc1" ->
          %Perseus.Boxes.Avc1{}

        "mp4a" ->
          %Perseus.Boxes.Mp4a{}

        type ->
          %Perseus.Boxes.Unknown{name: String.to_atom(type)}

      end

    box = Perseus.Box.parse(box, file, length - 8)
    Logger.debug(inspect(box))

    loop(IO.binread(file, 8), file, cnt + length, size, stsd |> Map.put(box.name, box))
  end

  def loop(:eof, _, _, _, stsd) do
    stsd
  end

  def loop(<<_::integer-32, _::binary-4>>, file, _, _, stsd) do
    # because the current pos is past next atom's length and name
    :file.position(file, {:cur, -8})
    stsd
  end

  def loop({:error, reason}, _, _, _, _) do
    Logger.debug("Error occurred while reading file #{reason}")
  end

  def parse(_, file, size) do
    <<_version::integer-32, entry_count::integer-32>> = IO.binread(file, 8)
    loop(IO.binread(file, 8), file, 0, size - 8, %Stsd{entry_count: entry_count})
  end
end
