require Logger

defmodule Stbl do
  defstruct(
    name: :stbl,
    stsd: nil,
    stts: nil,
    ctts: nil,
    stss: nil,
    stsc: nil,
    stsz: nil,
    stco: nil
  )

  defmodule Loop do
    def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, stbl)
        when cnt < size do
      Logger.debug("cnt: #{cnt}, size: #{size}, length: #{length}")

      box =
        case atom_type do
          "stsd" ->
            %Stsd{}

          "stts" ->
            %Stts{}

          "ctts" ->
            %Ctts{}

          "stss" ->
            %Stss{}

          "stsc" ->
            %Stsc{}

          "stsz" ->
            %Stsz{}

          "stco" ->
            %Stco{}

          type ->
            Logger.debug("Invalid atom type #{type} found during parsing")
            throw(atom_type)
        end

      box = Box.parse(box, file, length - 8)
      Logger.debug(inspect(box))

      loop(IO.binread(file, 8), file, cnt + length, size, stbl |> Map.put(box.name, box))
    end

    def loop(:eof, _, _, _, stbl) do
      stbl
    end

    def loop(<<_::integer-32, _::binary-4>>, file, _, _, stbl) do
      # because the current pos is past next atom's length and name
      :file.position(file, {:cur, -8})
      stbl
    end

    def loop({:error, reason}, _, _, _, _) do
      Logger.debug("Error occurred while reading file #{reason}")
    end
  end
end

defimpl Box, for: Stbl do
  def parse(_stbl, file, size) do
    Stbl.Loop.loop(IO.binread(file, 8), file, 8, size, %Stbl{})
  end
end
