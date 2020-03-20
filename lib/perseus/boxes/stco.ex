require Logger

defmodule Perseus.Boxes.Stco do
  defstruct(
    name: :stsc,
    entry_count: 0,
    chunk_offsets: []
  )
end

alias Perseus.Boxes.Stco

defimpl Perseus.Box, for: Stco do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      entry_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    chunk_offsets = for <<i::integer-32 <- rest>>, do: i

    %Stco{
      entry_count: entry_count,
      chunk_offsets: chunk_offsets
    }
  end
end
