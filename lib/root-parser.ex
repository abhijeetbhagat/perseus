require Logger

defmodule Parser do
  defstruct(boxes: [])

  defmodule Loop do
    def loop(<<length::integer-32, atom_type::binary-4>>, file, boxes) do
      box =
        case atom_type do
          "ftyp" ->
            %FTyp{}

          "moov" ->
            %Moov{}

          "free" ->
            %Free{}

          "mdat" ->
            %Mdat{}

          type ->
            Logger.debug("Invalid atom type #{type} found during parsing")
        end

      box = Box.parse(box, file, length)
      Logger.debug(inspect(box))
      Logger.debug("root-parse: cur pos: #{elem(:file.position(file, :cur), 1)}")

      loop(IO.binread(file, 8), file, [box | boxes])
    end

    def loop(:eof, _, boxes) do
      boxes
    end

    def loop({:error, reason}, _, _) do
      Logger.debug("Error occurred while reading file #{reason}")
    end
  end

  def parse(path) do
    Logger.debug("Path: #{path}")

    with {:ok, file} = File.open(path) do
      boxes = Parser.Loop.loop(IO.binread(file, 8), file, [])
      %Parser{boxes: boxes}
    end
  end
end
