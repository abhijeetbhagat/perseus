require Logger

defmodule Perseus.Boxes.Tkhd do
  defstruct(
    name: :tkhd,
    creation_time: 0,
    modification_time: 0,
    timescale: 0,
    duration: 0,
    reserved1: 0,
    track_id: 0,
    reserved2: [],
    reserved3: 0,
    layer: 0,
    alternate_group: 0,
    volume: 0,
    width: 0,
    height: 0
  )
end

alias Perseus.Boxes.Tkhd

defimpl Perseus.Box, for: Tkhd do
  def parse(_, file, size) do
    {
      creation_time,
      modification_time,
      track_id,
      reserved1,
      duration,
      reserved2,
      layer,
      alternate_group,
      volume,
      reserved3,
      width,
      height
    } = extract_meta(IO.binread(file, size))

    %Tkhd{
      creation_time: creation_time,
      modification_time: modification_time,
      track_id: track_id,
      reserved1: reserved1,
      duration: duration,
      reserved2: reserved2,
      layer: layer,
      alternate_group: alternate_group,
      volume: volume,
      reserved3: reserved3,
      width: width,
      height: height
    }
  end

  defp extract_meta(<<0::integer-8, rest::binary>>) do
    Logger.debug("tkhd: rest size: #{byte_size(rest)}")

    <<
      _::binary-size(3),
      creation_time::integer-32,
      modification_time::integer-32,
      track_id::integer-32,
      reserved1::integer-32,
      duration::integer-32,
      reserved2_1::integer-32,
      reserved2_2::integer-32,
      layer::integer-16,
      alternate_group::integer-16,
      volume::integer-16,
      reserved3::integer-16,
      _::binary-size(36),
      width::integer-16,
      _::binary-size(2),
      height::integer-16,
      _::binary-size(2)
    >> = rest

    {
      creation_time,
      modification_time,
      track_id,
      reserved1,
      duration,
      [reserved2_1, reserved2_2],
      layer,
      alternate_group,
      volume,
      reserved3,
      width,
      height
    }
  end

  defp extract_meta(<<_version::integer-8, rest::binary>>) do
    <<
      _::binary-size(3),
      creation_time::integer-64,
      modification_time::integer-64,
      track_id::integer-32,
      reserved1::integer-32,
      duration::integer-64,
      reserved2_1::integer-32,
      reserved2_2::integer-32,
      layer::integer-16,
      alternate_group::integer-16,
      volume::integer-16,
      reserved3::integer-16,
      _::binary-size(36),
      width::integer-16,
      _::binary-size(16),
      height::integer-16,
      _::binary-size(16)
    >> = rest

    {
      creation_time,
      modification_time,
      track_id,
      reserved1,
      duration,
      [reserved2_1, reserved2_2],
      layer,
      alternate_group,
      volume,
      reserved3,
      width,
      height
    }
  end
end
