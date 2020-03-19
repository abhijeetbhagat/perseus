require Logger
defmodule Elst do
  defstruct(
    name: :elst,
    entry_count: 0,
    segment_duration: [],
    media_time: [],
    media_rate_integer: 0,
    media_rate_fraction: 0
  )
end

defimpl Box, for: Elst do
  def parse(_, file, size) do
    {
      entry_count,
      segment_duration,
      media_time,
      media_rate_integer,
      media_rate_fraction
    } = extract_meta(IO.binread(file, size))

    %Elst{
      entry_count: entry_count,
      segment_duration: segment_duration,
      media_time: media_time,
      media_rate_integer: media_rate_integer,
      media_rate_fraction: media_rate_fraction
    }
  end

  def loop(
        v,
        <<
          segment_duration::integer-32,
          media_time::integer-32,
          media_rate_integer::integer-16,
          media_rate_fraction::integer-16,
          rest::binary
        >>,
        sd_l,
        mt_l,
        mri_l,
        mrf_l,
        cnt,
        entry_count
      )
      when cnt < entry_count do
    loop(
      v,
      rest,
      sd_l ++ [segment_duration],
      mt_l ++ [media_time],
      mri_l ++ [media_rate_integer],
      mrf_l ++ [media_rate_fraction],
      cnt + 1,
      entry_count
    )
  end

  def loop(
        1,
        <<
          segment_duration::integer-64,
          media_time::integer-64,
          media_rate_integer::integer-16,
          media_rate_fraction::integer-16,
          rest::binary
        >>,
        sd_l,
        mt_l,
        mri_l,
        mrf_l,
        cnt,
        entry_count
      )
      when cnt < entry_count do
    loop(
      1,
      rest,
      sd_l ++ [segment_duration],
      mt_l ++ [media_time],
      mri_l ++ [media_rate_integer],
      mrf_l ++ [media_rate_fraction],
      cnt + 1,
      entry_count
    )
  end

  def loop(_, _, sd_l, mt_l, mri_l, mrf_l, _, entry_count) do
    {entry_count, sd_l, mt_l, mri_l, mrf_l}
  end

  def extract_meta(<<version::integer-32, entry_count::integer-32, rest::binary>>) do
    loop(version, rest, [], [], [], [], 0, entry_count)
  end

  def extract_meta(<<1::integer-32, entry_count::integer-32, rest::binary>>) do
    loop(1, rest, [], [], [], [], 0, entry_count)
  end
end
