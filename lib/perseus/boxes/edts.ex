require Logger

defmodule Perseus.Boxes.Edts do
  defstruct(
    name: :edts,
    elst: nil
  )

  defmodule Loop do
    def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, edts)
        when cnt < size do
      Logger.debug("cnt: #{cnt}, size: #{size}, length: #{length}")

      box =
        case atom_type do
          "elst" ->
            %Perseus.Boxes.Elst{}

          type ->
            Logger.debug("Invalid atom type #{type} found during parsing")
            throw(atom_type)
        end

      box = Perseus.Box.parse(box, file, length - 8)
      Logger.debug(inspect(box))

      loop(IO.binread(file, 8), file, cnt + length, size, edts |> Map.put(box.name, box))
    end

    def loop(:eof, _, _, _, edts) do
      edts
    end

    def loop(<<_::integer-32, _::binary-4>>, file, _, _, edts) do
      # because the current pos is past next atom's length and name
      :file.position(file, {:cur, -8})
      edts
    end

    def loop({:error, reason}, _, _, _, _) do
      Logger.debug("Error occurred while reading file #{reason}")
    end
  end
end

alias Perseus.Boxes.Edts

defimpl Perseus.Box, for: Edts do
  def parse(_, file, size) do
    Edts.Loop.loop(IO.binread(file, 8), file, 8, size, %Edts{})
  end
end
