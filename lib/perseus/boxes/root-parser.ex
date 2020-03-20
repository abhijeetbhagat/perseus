require Logger

defmodule Perseus.Parser do
  defstruct(boxes: [])

  defp loop(<<length::integer-32, atom_type::binary-4>>, file, boxes) do
    box =
      case atom_type do
        "ftyp" ->
          %Perseus.Boxes.FTyp{}

        "moov" ->
          %Perseus.Boxes.Moov{}

        "free" ->
          %Perseus.Boxes.Free{}

        "mdat" ->
          %Perseus.Boxes.Mdat{}

        type ->
          %Perseus.Boxes.Unknown{name: String.to_atom(type)}
      end

    box = Perseus.Box.parse(box, file, length - 8)
    Logger.debug(inspect(box))
    Logger.debug("root-parse: cur pos: #{elem(:file.position(file, :cur), 1)}")

    loop(IO.binread(file, 8), file, boxes |> Map.put(box.name, box))
  end

  defp loop(:eof, _, boxes) do
    boxes
  end

  defp loop({:error, reason}, _, _) do
    Logger.debug("Error occurred while reading file #{reason}")
  end

  def parse(path) do
    Logger.debug("Path: #{path}")

    with {:ok, file} = File.open(path) do
      boxes = loop(IO.binread(file, 8), file, %{})
      boxes
    end
  end
end
