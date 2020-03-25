# Perseus
[![Hex.pm](https://img.shields.io/badge/hex-v0.1.1-orange)](https://hex.pm/packages/perseus)
[![Hexdocs.pm](https://img.shields.io/badge/api-hexdocs-brightgreen)](https://hexdocs.pm/perseus)

An ISO-BMFF file parser.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `perseus` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:perseus, "~> 0.1.1"}
  ]
end
```

## Usage
```
iex> Perseus.get_meta(~S(C:\\Users\\abhagat\\code\\mp4box\\test\\output_squirrel.mp4))
%{
  free: %Perseus.Boxes.Free{
    data: "IsoMedia File Produced with GPAC 0.8.0-rev9-g6e4af05b-master",
    name: :free
  },
  ftyp: %Perseus.Boxes.FTyp{
    compatible_brands: ["isom", "avc1"],
    major_brand: "isom",
    minor_version: 1,
    name: :ftyp
  },
  ...
}
```