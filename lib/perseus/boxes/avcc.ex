require Logger
use Bitwise

defmodule Perseus.Boxes.Avcc do
  defstruct(
    name: :avcc,
    config_version: 0,
    profile_indication: 0,
    profile_compatibility: 0,
    level_indication: 0,
    len_size_minus_one: 0,
    num_sps: 0,
    sps_len: [],
    sps_nalus: [],
    num_pps: 0,
    pps_len: [],
    pps_nalus: []
  )

  defmodule Loop do
    def loop(
          <<len::integer-16, nalu::binary-size(len), rest::binary>>,
          len_l,
          nalu_l,
          cnt,
          size
        )
        when cnt < size do
      loop(rest, len_l ++ [len], nalu_l ++ [nalu], cnt + 1, size)
    end

    def loop(rest, len_l, nalu_l, _, _) do
      {rest, len_l, nalu_l}
    end
  end
end

alias Perseus.Boxes.Avcc

defimpl Perseus.Box, for: Avcc do
  def parse(_, file, size) do
    <<
      config_version::integer-8,
      profile_indication::integer-8,
      profile_compatibility::integer-8,
      level_indication::integer-8,
      len_size_minus_one::integer-8,
      rest::binary
    >> = IO.binread(file, size)

    len_size_minus_one = len_size_minus_one &&& 3

    <<num_sps::integer-8, rest::binary>> = rest
    num_sps = num_sps &&& 0x1F
    {rest, sps_len_l, sps_nalu_l} = Avcc.Loop.loop(rest, [], [], 0, num_sps)
    <<num_pps::integer-8, rest::binary>> = rest
    {_rest, pps_len_l, pps_nalu_l} = Avcc.Loop.loop(rest, [], [], 0, num_pps)

    %Avcc{
      config_version: config_version,
      profile_indication: profile_indication,
      profile_compatibility: profile_compatibility,
      level_indication: level_indication,
      len_size_minus_one: len_size_minus_one,
      num_sps: num_sps,
      sps_len: sps_len_l,
      sps_nalus: sps_nalu_l,
      num_pps: num_pps,
      pps_len: pps_len_l,
      pps_nalus: pps_nalu_l
    }
  end
end
