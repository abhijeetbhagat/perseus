require Logger

defmodule Perseus.Boxes.Moov do
  defstruct(
    name: :moov,
    mvhd: nil,
    trak: nil,
    iods: nil,
    udta: nil
  )

  defmodule Loop do
    def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, moov)
        when cnt < size do
      Logger.debug(
        "moov: cnt: #{cnt}, size: #{size}, length: #{length} cur pos: #{
          elem(:file.position(file, :cur), 1)
        }"
      )

      box =
        case atom_type do
          "iods" ->
            %Perseus.Boxes.Iods{}

          "udta" ->
            %Perseus.Boxes.Udta{}

          "mvhd" ->
            %Perseus.Boxes.Mvhd{}

          "trak" ->
            %Perseus.Boxes.Trak{}

          type ->
            Logger.debug("Invalid atom type #{type} found during parsing")
            throw(atom_type)
        end

      Logger.debug("moov: about to parse #{atom_type}")
      box = Perseus.Box.parse(box, file, length - 8)
      Logger.debug(inspect(box))

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
      Logger.debug("Error occurred while reading file #{reason}")
    end
  end
end

alias Perseus.Boxes.Moov

defimpl Perseus.Box, for: Moov do
  def parse(_moov, file, size) do
    Moov.Loop.loop(IO.binread(file, 8), file, 8, size, %Moov{})
  end
end
