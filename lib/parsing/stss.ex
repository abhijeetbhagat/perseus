defmodule Stss do
  defstruct(
    name: :stss,
    entry_count: 0,
    sample_number: []
  )

  defmodule Loop do
    def loop(<<sn::integer-32, rest::binary>>, sn_l) do
      loop(rest, sn_l ++ [sn])
    end

    def loop(<<>>, sn_l) do
      sn_l
    end
  end
end

defimpl Box, for: Stss do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      entry_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    sn_l = Stss.Loop.loop(rest, [])

    %Stss{
      entry_count: entry_count,
      sample_number: sn_l
    }
  end
end
