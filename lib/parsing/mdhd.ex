use Bitwise

defmodule Mdhd do
  defstruct(
    name: :mdhd,
    creation_time: 0,
    modification_time: 0,
    timescale: 0,
    duration: 0,
    pad: 0,
    language: <<>>,
    predefined: 0
  )
end

defimpl Box, for: Mdhd do
  def parse(_, file, size) do
    IO.puts("mdhd: size: #{size} pos: #{elem(:file.position(file, :cur), 1)}")

    {
      creation_time,
      modification_time,
      timescale,
      duration,
      pad,
      language,
      predefined
    } = extract_meta(IO.binread(file, size))

    %Mdhd{
      creation_time: creation_time,
      modification_time: modification_time,
      timescale: timescale,
      duration: duration,
      pad: pad,
      language: language,
      predefined: predefined
    }
  end

  def extract_meta(<<0::integer-32, rest::binary>>) do
    <<
      creation_time::integer-32,
      modification_time::integer-32,
      timescale::integer-32,
      duration::integer-32,
      data::integer-16,
      predefined::integer-16
    >> = rest

    {
      creation_time,
      modification_time,
      timescale,
      duration,
      data >>> 15 &&& 1,
      get_lang(data),
      predefined
    }
  end

  def extract_meta(<<_version::integer-32, rest::binary>>) do
    <<
      creation_time::integer-64,
      modification_time::integer-64,
      timescale::integer-32,
      duration::integer-64,
      data::integer-16,
      predefined::integer-16
    >> = rest

    {
      creation_time,
      modification_time,
      timescale,
      duration,
      data >>> 15 &&& 1,
      get_lang(data),
      predefined
    }
  end

  defp get_lang(data) do
    lang = data &&& 0x7FFF

    <<
      97 + rem((lang >>> 10) - 1, 97),
      97 + rem((lang >>> 5 &&& 0x1F) - 1, 97),
      97 + rem((lang &&& 0x1F) - 1, 97)
    >>
  end
end
