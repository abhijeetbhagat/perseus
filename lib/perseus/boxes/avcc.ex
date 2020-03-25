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
end

alias Perseus.Boxes.Avcc

defimpl Perseus.Box, for: Avcc do
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
    {rest, sps_len_l, sps_nalu_l} = loop(rest, [], [], 0, num_sps)
    <<num_pps::integer-8, rest::binary>> = rest
    {rest, pps_len_l, pps_nalu_l} = loop(rest, [], [], 0, num_pps)

    avcc =
      case profile_indication == 100 or
             profile_indication == 110 or
             profile_indication == 122 or
             profile_indication == 144 do
        n when n in [100, 110, 122, 144] ->
          <<
            _::size(6),
            chroma_format::integer-2,
            _::size(5),
            bit_depth_luma_minus8::integer-3,
            _::size(5),
            bit_depth_chroma_minus8::integer-3,
            _rest::binary
          >> = rest

          %Avcc{}
          |> Map.put(:chroma_format, chroma_format)
          |> Map.put(:bit_depth_luma_minus8, bit_depth_luma_minus8)
          |> Map.put(:bit_depth_chroma_minus8, bit_depth_chroma_minus8)

        _ ->
          %Avcc{}
      end

    avcc
    |> Map.put(:config_version, config_version)
    |> Map.put(:profile_indication, profile_indication)
    |> Map.put(:profile_compatibility, profile_compatibility)
    |> Map.put(:level_indication, level_indication)
    |> Map.put(:len_size_minus_one, len_size_minus_one)
    |> Map.put(:num_sps, num_sps)
    |> Map.put(:sps_len, sps_len_l)
    |> Map.put(:sps_nalus, sps_nalu_l)
    |> Map.put(:num_pps, num_pps)
    |> Map.put(:pps_len, pps_len_l)
    |> Map.put(:pps_nalus, pps_nalu_l)
  end
end
