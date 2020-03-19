require Logger
defmodule Stsz do
  defstruct(
    name: :stts,
    sample_size: 0,
    sample_count: 0,
    entry_size: []
  )
end

defimpl Box, for: Stsz do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      sample_size::integer-32,
      sample_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    entry_size =
      if sample_size == 0 do
        for <<i::integer-32 <- rest>>, do: i
      else
        nil
      end

    %Stsz{
      sample_size: sample_size,
      sample_count: sample_count,
      entry_size: entry_size
    }
  end
end
