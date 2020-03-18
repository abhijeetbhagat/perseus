defmodule Avc1 do
  defstruct(
    name: :avc1,
    data_ref_index: 0,
    vid_enc_version: 0,
    vid_enc_revision_lvl: 0,
    vid_enc_vendor: 0,
    vid_temporal_quality: 0,
    vid_spatial_quality: 0,
    vid_frame_pixel_size: 0,
    vid_resolution: 0,
    vid_data_size: 0,
    vid_frame_count: 0,
    vid_enc_name_len: 0,
    vid_enc_name: 0,
    vid_pixel_depth: 0,
    vid_color_tbl_id: 0
  )

  defmodule Loop do
    def loop(<<length::integer-32, atom_type::binary-4>>, file, cnt, size, avc1)
        when cnt < size do
      box =
        case atom_type do
          "avcC" ->
            %Avcc{}

          "btrt" ->
            %Btrt{}

          "colr" ->
            %Colr{}

          "pasp" ->
            %Pasp{}

          type ->
            IO.puts("avc1: Invalid atom type #{type} found during parsing")
        end

      box = Box.parse(box, file, length - 8)
      loop(IO.binread(file, 8), file, cnt + length, size, avc1 |> Map.put(box.name, box))
    end

    def loop(:eof, _, _, _, mdia) do
      mdia
    end

    def loop(<<_::integer-32, _::binary-4>>, file, _, _, mdia) do
      # because the current pos is past next atom's length and name
      :file.position(file, {:cur, -8})
      mdia
    end

    def loop({:error, reason}, _, _, _, _) do
      IO.puts("Error occurred while reading file #{reason}")
    end
  end
end

defimpl Box, for: Avc1 do
  def parse(_, file, size) do
    <<
      _::binary-size(6),
      data_ref_index::integer-16,
      vid_enc_version::integer-16,
      vid_enc_revision_lvl::integer-16,
      vid_enc_vendor::binary-4,
      vid_temporal_quality::integer-32,
      vid_spatial_quality::integer-32,
      vid_frame_pixel_size::integer-32,
      vid_resolution::integer-64,
      vid_data_size::integer-32,
      vid_frame_count::integer-16,
      vid_enc_name_len::integer-8,
      vid_enc_name::binary-size(vid_enc_name_len),
      rest::binary
    >> = IO.binread(file, 78)

    s = 31 - vid_enc_name_len

    <<
      _::binary-size(s),
      vid_pixel_depth::integer-16,
      vid_color_tbl_id::integer-16
    >> = rest

    avc1 = %Avc1{
      data_ref_index: data_ref_index,
      vid_enc_version: vid_enc_version,
      vid_enc_revision_lvl: vid_enc_revision_lvl,
      vid_enc_vendor: vid_enc_vendor,
      vid_temporal_quality: vid_temporal_quality,
      vid_spatial_quality: vid_spatial_quality,
      vid_frame_pixel_size: vid_frame_pixel_size,
      vid_resolution: vid_resolution,
      vid_data_size: vid_data_size,
      vid_frame_count: vid_frame_count,
      vid_enc_name_len: vid_enc_name_len,
      vid_enc_name: vid_enc_name,
      vid_pixel_depth: vid_pixel_depth,
      vid_color_tbl_id: vid_color_tbl_id
    }

    IO.puts(inspect(avc1))
    IO.puts("avc1: pos after avc1 parsing: #{elem(:file.position(file, :cur), 1)}")

    Avc1.Loop.loop(IO.binread(file, 8), file, 86 + 8, size, avc1)
  end
end
