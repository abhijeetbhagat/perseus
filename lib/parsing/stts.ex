defmodule Stts do
  defstruct(
    name: :stts,
    entry_count: 0,
    sample_count: [],
    sample_delta: []
  )

  defmodule Loop do
    def loop(<<sc::integer-32, sd::integer-32, rest::binary>>, sc_l, sd_l) do
      loop(rest, sc_l ++ [sc], sd_l ++ [sd])
    end

    def loop(<<>>, sc_l, sd_l) do
      {sc_l, sd_l}
    end
  end
end

defimpl Box, for: Stts do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      entry_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    {sc_l, sd_l} = Stts.Loop.loop(rest, [], [])

    %Stts{
      entry_count: entry_count,
      sample_count: sc_l,
      sample_delta: sd_l
    }
  end
end
