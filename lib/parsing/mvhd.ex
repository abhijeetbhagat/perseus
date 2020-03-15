defmodule Mvhd do
  defstruct(
    name: :mvhd,
    creation_time: 0,
    modification_time: 0,
    timescale: 0,
    duration: 0,
    next_track_id: 0
  )
end

defimpl Box, for: Mvhd do
  def parse(_, file, size) do
    IO.puts("mvhd: size: #{size} pos: #{elem(:file.position(file, :cur), 1)}")

    {
      creation_time,
      modification_time,
      timescale,
      duration,
      next_track_id
    } = extract_meta(IO.binread(file, size))

    %Mvhd{
      creation_time: creation_time,
      modification_time: modification_time,
      timescale: timescale,
      duration: duration,
      next_track_id: next_track_id
    }
  end

  def extract_meta(<<0::integer-32, rest::binary>>) do
    <<
      creation_time::integer-32,
      modification_time::integer-32,
      timescale::integer-32,
      duration::integer-32,
      _::binary-size(76),
      next_track_id::integer-32
    >> = rest

    {
      creation_time,
      modification_time,
      timescale,
      duration,
      next_track_id
    }
  end

  def extract_meta(<<_version::integer-32, rest::binary>>) do
    <<
      creation_time::integer-64,
      modification_time::integer-64,
      timescale::integer-32,
      duration::integer-64,
      _::binary-size(76),
      next_track_id::integer-32
    >> = rest

    {
      creation_time,
      modification_time,
      timescale,
      duration,
      next_track_id
    }
  end
end
