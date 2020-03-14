defmodule Moov do
  defstruct(
    mvhd: nil,
    trak: nil,
    iods: nil,
    udta: nil
  )

  defmodule Loop do
    def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, moov)
        when cnt < size do
      IO.puts("cnt: #{cnt}, size: #{size}, length: #{length}")

      box =
        case atom_type do
          "iods" ->
            %Iods{}

          "udta" ->
            %Udta{}

          "mvhd" ->
            %Mvhd{}

          "trak" ->
            %Trak{}

          type ->
            IO.puts("Invalid atom type #{type} found during parsing")
        end

      box = Box.parse(box, file, length)
      IO.puts(inspect(box))

      loop(IO.binread(file, 8), file, cnt + length, size, Map.update(moov, atom_type, box, & &1))
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

defimpl Box, for: Moov do
  def parse(_moov, file, size) do
    Moov.Loop.loop(IO.binread(file, 8), file, 8, size, %Moov{})
  end
end
