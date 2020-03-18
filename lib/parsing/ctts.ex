defmodule Ctts do
  defstruct(
    name: :ctts,
    entry_count: 0,
    sample_count: [],
    sample_offset: []
  )

  defmodule Loop do
    def loop(<<sc::integer-32, so::integer-32, rest::binary>>, sc_l, so_l) do
      loop(rest, sc_l ++ [sc], so_l ++ [so])
    end

    def loop(<<>>, sc_l, so_l) do
      {sc_l, so_l}
    end
  end
end

defimpl Box, for: Ctts do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      entry_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    {sc_l, so_l} = Ctts.Loop.loop(rest, [], [])

    %Ctts{
      entry_count: entry_count,
      sample_count: sc_l,
      sample_offset: so_l
    }
  end
end
