defmodule Mdia do
  defstruct(
    name: :mdia,
    mdhd: nil,
    hdlr: nil,
    minf: nil
  )

  defmodule Loop do
    def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, moov)
        when cnt < size do
      IO.puts("cnt: #{cnt}, size: #{size}, length: #{length}")

      box =
        case atom_type do
          "mdhd" ->
            %Mdhd{}

          "hdlr" ->
            %Hdlr{}

          "minf" ->
            %Minf{}

          type ->
            IO.puts("Invalid atom type #{type} found during parsing")
            throw(atom_type)
        end

      box = Box.parse(box, file, length - 8)
      IO.puts(inspect(box))

      loop(IO.binread(file, 8), file, cnt + length, size, moov |> Map.put(box.name, box))
    end

    def loop(:eof, _, _, _, moov) do
      moov
    end

    def loop(<<_::integer-32, _::binary-4>>, file, _, _, moov) do
      # because the current pos is past next atom's length and name
      :file.position(file, {:cur, -8})
      moov
    end

    def loop({:error, reason}, _, _, _, _) do
      IO.puts("Error occurred while reading file #{reason}")
    end
  end
end

defimpl Box, for: Mdia do
  def parse(_moov, file, size) do
    Mdia.Loop.loop(IO.binread(file, 8), file, 8, size, %Mdia{})
  end
end
