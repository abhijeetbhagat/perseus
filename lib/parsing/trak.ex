require Logger

defmodule Trak do
  defstruct(
    name: :trak,
    tkhd: nil,
    edts: nil,
    mdia: nil
  )

  defmodule Loop do
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
            %Tkhd{}

          "edts" ->
            %Edts{}

          "mdia" ->
            %Mdia{}

          "udta" ->
            %Udta{}

          type ->
            Logger.debug("Invalid atom type #{type} found during parsing")
            throw(atom_type)
        end

      box = Box.parse(box, file, length - 8)
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
  end
end

defimpl Box, for: Trak do
  def parse(_, file, size) do
    # :file.position(file, {:cur, size})
    # %Trak{}
    Trak.Loop.loop(IO.binread(file, 8), file, 0, size, %Trak{})
  end
end
