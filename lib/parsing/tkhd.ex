defmodule Tkhd do
  defstruct(
    name: :tkhd,
    creation_time: 0,
    modification_time: 0,
    timescale: 0,
    duration: 0,
    next_track_id: 0,
    reserved2: [],
    reserved3: 0,
    layer: 0,
    alternate_group: 0,
    volume: 0,
    width: 0,
    height: 0
  )
end

defimpl Box, for: Tkhd do
  def parse(_, file, _) do
    <<version::integer-8, flags::integer-32>> = IO.binread(file, 4)

    tkhd = %Tkhd{}

    tkhd =
      if version == 0 do
        <<creation_time::integer-32, modification_time::integer-32, track_id::integer-32,
          reserved1::integer-32, duration::integer-32>> = IO.binread(file, 20)

        tkhd
        |> Map.put(:creation_time, creation_time)
        |> Map.put(:modification_time, modification_time)
        |> Map.put(:track_id, track_id)
        |> Map.put(:reserved1, reserved1)
        |> Map.put(:duration, duration)
      else
        <<creation_time::integer-64, modification_time::integer-64, track_id::integer-32,
          reserved1::integer-32, duration::integer-64>> = IO.binread(file, 32)

        tkhd
        |> Map.put(:creation_time, creation_time)
        |> Map.put(:modification_time, modification_time)
        |> Map.put(:track_id, track_id)
        |> Map.put(:reserved1, reserved1)
        |> Map.put(:duration, duration)
      end

    # extract two 4 bytes ints from the file and store them in a list
    reserved_bytes = for <<reserved::integer-32 <- IO.binread(file, 16)>>, do: reserved

    <<layer::integer-16, alternate_group::integer-16, volume::integer-16, reserved3::integer-16>> =
      IO.binread(file, 8)

    # if track is audio, then set volume to 1 else 0
    # for now, set it to 0 until we figure how to check the track type
    :file.position(file, {:cur, 36})
    # TODO abhi - width and height values are stored as fixed point 16.16 values
    # not sure how to convert that to float at this point in time. But reading
    # the first 16 bits and treating them as a value does the job.
    <<width::integer-16>> = IO.binread(file, 2)
    :file.position(file, {:cur, 2})
    <<height::integer-16>> = IO.binread(file, 2)
    :file.position(file, {:cur, 2})

    tkhd
    |> Map.put(:reserved2, reserved_bytes)
    |> Map.put(:layer, layer)
    |> Map.put(:alternate_group, alternate_group)
    |> Map.put(:volume, volume)
    |> Map.put(:reserved3, reserved3)
    |> Map.put(:width, width)
    |> Map.put(:height, height)
  end
end
