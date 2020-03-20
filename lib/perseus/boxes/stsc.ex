require Logger

defmodule Perseus.Boxes.Stsc do
  defstruct(
    name: :stsc,
    entry_count: 0,
    first_chunk: [],
    samples_per_chunk: [],
    sample_desc_index: []
  )
end

alias Perseus.Boxes.Stsc

defimpl Perseus.Box, for: Stsc do
  def parse(_, file, size) do
    <<
      _version::integer-32,
      entry_count::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    {fc_l, spc_l, sdi_l} =
      Enum.reduce(
        Enum.zip(
          Stream.cycle([1, 2, 3]),
          for <<i::integer-32 <- rest>> do
            i
          end
        ),
        {[], [], []},
        fn x, {a, b, c} ->
          case elem(x, 0) do
            1 -> {a ++ [elem(x, 1)], b, c}
            2 -> {a, b ++ [elem(x, 1)], c}
            3 -> {a, b, c ++ [elem(x, 1)]}
          end
        end
      )

    %Stsc{
      entry_count: entry_count,
      first_chunk: fc_l,
      samples_per_chunk: spc_l,
      sample_desc_index: sdi_l
    }
  end
end
