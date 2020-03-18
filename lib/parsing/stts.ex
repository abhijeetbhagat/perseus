defmodule Stts do
  defstruct(
    name: :stts,
    entry_count: 0,
    sample_count: [],
    sample_delta: []
  )

  defmodule Loop do
    def loop(<<sc::integer-32, sd::integer-32, rest::binary>>, cnt, size, sc_l, sd_l)
        when cnt < size do
      loop(rest, cnt + 1, size, sc_l ++ [sc], sd_l ++ [sd])
    end

    def loop(_rest, _, _, sc_l, sd_l) do
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

    {sc_l, sd_l} = Stts.Loop.loop(rest, 0, entry_count, [], [])

    %Stts{
      entry_count: entry_count,
      sample_count: sc_l,
      sample_delta: sd_l
    }
  end
end
