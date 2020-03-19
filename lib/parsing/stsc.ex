require Logger
defmodule Stsc do
  defstruct(
    name: :stsc,
    entry_count: 0,
    first_chunk: [],
    samples_per_chunk: [],
    sample_desc_index: []
  )

  defmodule Loop do
    def loop(
          <<fc::integer-32, spc::integer-32, sdi::integer-32, rest::binary>>,
          fc_l,
          spc_l,
          sdi_l
        ) do
      loop(rest, fc_l ++ [fc], spc_l ++ [spc], sdi_l ++ [sdi])
    end

    def loop(<<>>, fc_l, spc_l, sdi_l) do
      {fc_l, spc_l, sdi_l}
    end
  end
end

defimpl Box, for: Stsc do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      entry_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    {fc_l, spc_l, sdi_l} = Stsc.Loop.loop(rest, [], [], [])

    %Stsc{
      entry_count: entry_count,
      first_chunk: fc_l,
      samples_per_chunk: spc_l,
      sample_desc_index: sdi_l
    }
  end
end
