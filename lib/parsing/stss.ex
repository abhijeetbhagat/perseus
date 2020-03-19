require Logger
defmodule Stss do
  defstruct(
    name: :stss,
    entry_count: 0,
    sample_number: []
  )
end

defimpl Box, for: Stss do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      entry_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    sn_l = for <<i::integer-32 <- rest>>, do: i

    %Stss{
      entry_count: entry_count,
      sample_number: sn_l
    }
  end
end
