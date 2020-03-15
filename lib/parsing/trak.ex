defmodule Trak do
  defstruct(
    name: :trak,
    data: nil
  )

  defmodule Loop do
    def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, moov)
        when cnt < size do
      IO.puts(
        "tkhd: cnt: #{cnt}, size: #{size}, length: #{length} pos: #{
          elem(:file.position(file, :cur), 1)
        }"
      )

      box =
        case atom_type do
          "tkhd" ->
            %Tkhd{}

          "edts" ->
            %Edts{}

          "mdia" ->
            %Mdia{}

          "udta" ->
            %Udta{}

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

defimpl Box, for: Trak do
  def parse(_, file, size) do
    # :file.position(file, {:cur, size})
    # %Trak{}
    Trak.Loop.loop(IO.binread(file, 8), file, 0, size, %Trak{})
  end
end
