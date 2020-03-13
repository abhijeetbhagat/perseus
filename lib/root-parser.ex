defmodule Parser do
  defstruct(boxes: [])

  defmodule Loop do
    def loop(<<length::integer-32, atom_type::binary-4>>, file, boxes) do
      box = nil

      case atom_type do
        "ftyp" ->
          box = FTyp.parse_ftyp(file, length)
          IO.puts(inspect(box))

        "moov" ->
          box = Moov.parse_ftyp(file, length)
          IO.puts(inspect(box))

        "free" ->
          box = Free.parse_ftyp(file, length)
          IO.puts(inspect(box))

        "mdat" ->
          box = Mdat.parse_ftyp(file, length)
          IO.puts(inspect(box))

        type ->
          IO.puts("Invalid atom type #{type} found during parsing")
      end

      loop(IO.binread(file, 8), file, [box | boxes])
    end

    def loop(:eof, _file, boxes) do
      boxes
    end

    def loop({:error, reason}, _file, _boxes) do
      IO.puts("Error occurred while reading file #{reason}")
    end
  end

  def parse(path) do
    IO.puts("Path: #{path}")

    with {:ok, file} = File.open(path) do
      boxes = Parser.Loop.loop(IO.binread(file, 8), file, [])
      %Parser{boxes: boxes}
    end
  end
end
