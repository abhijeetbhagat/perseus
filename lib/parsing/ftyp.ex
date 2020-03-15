defmodule FTyp do
  defstruct(
    major_brand: "",
    minor_version: 0,
    compatible_brands: []
  )

  defmodule Loop do
    def loop(_file, l, 0) do
      l
    end

    def loop(file, l, i) do
      <<compatible_brand::binary-4>> = IO.binread(file, 4)
      loop(file, [compatible_brand | l], i - 4)
    end
  end
end

defimpl Box, for: FTyp do
  def parse(_, file, size) do
    <<major_brand::binary-4, minor_version::integer-32>> = IO.binread(file, 8)
    brands = FTyp.Loop.loop(file, [], size - 16)
    %FTyp{major_brand: major_brand, minor_version: minor_version, compatible_brands: brands}
  end
end
