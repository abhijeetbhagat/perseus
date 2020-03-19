require Logger

defmodule Ctts do
  defstruct(
    name: :ctts,
    entry_count: 0,
    sample_count: [],
    sample_offset: []
  )
end

defimpl Box, for: Ctts do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      entry_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    {sc_l, so_l} =
      Enum.reduce(
        Enum.zip(
          1..entry_count,
          for <<i::integer-32 <- rest>> do
            i
          end
        ),
        {[], []},
        fn x, {a, b} ->
          if rem(elem(x, 0), 2) == 1 do
            {a ++ [elem(x, 1)], b}
          else
            {a, b ++ [elem(x, 1)]}
          end
        end
      )

    %Ctts{
      entry_count: entry_count,
      sample_count: sc_l,
      sample_offset: so_l
    }
  end
end
