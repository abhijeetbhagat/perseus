require Logger

defmodule Perseus.Boxes.FTyp do
  defstruct(
    name: :ftyp,
    major_brand: "",
    minor_version: 0,
    compatible_brands: []
  )
end

alias Perseus.Boxes.FTyp

defimpl Perseus.Box, for: FTyp do
  def parse(_, file, size) do
    <<major_brand::binary-4, minor_version::integer-32, rest::binary>> = IO.binread(file, size)

    brands = for <<cb::binary-4 <- rest>>, do: cb
    %FTyp{major_brand: major_brand, minor_version: minor_version, compatible_brands: brands}
  end
end
