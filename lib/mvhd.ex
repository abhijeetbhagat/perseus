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
  def parse(_, file, _) do
    <<version::integer-32>> = IO.binread(file, 4)

    mvhd = %Mvhd{}

    mvhd =
      if version == 0 do
        <<creation_time::integer-32>> = IO.binread(file, 4)
        <<modification_time::integer-32>> = IO.binread(file, 4)
        <<timescale::integer-32>> = IO.binread(file, 4)
        <<duration::integer-32>> = IO.binread(file, 4)

        mvhd
        |> Map.put(:creation_time, creation_time)
        |> Map.put(:modification_time, modification_time)
        |> Map.put(:timescale, timescale)
        |> Map.put(:duration, duration)
      else
        <<creation_time::integer-64>> = IO.binread(file, 8)
        <<modification_time::integer-64>> = IO.binread(file, 8)
        <<timescale::integer-32>> = IO.binread(file, 4)
        <<duration::integer-64>> = IO.binread(file, 8)

        mvhd
        |> Map.put(:creation_time, creation_time)
        |> Map.put(:modification_time, modification_time)
        |> Map.put(:timescale, timescale)
        |> Map.put(:duration, duration)
      end

    :file.position(file, {:cur, 76})
    <<next_track_id::integer-32>> = IO.binread(file, 4)
    mvhd |> Map.put(:next_track_id, next_track_id)
  end
end
