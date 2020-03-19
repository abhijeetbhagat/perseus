require Logger
defmodule Hdlr do
  defstruct(
    name: :hdlr,
    predefined: 0,
    handler_type: <<>>,
    reserved: [],
    handler_name: <<>>
  )
end

defimpl Box, for: Hdlr do
  def parse(_, file, size) do
    <<
      _::binary-size(4),
      predefined::integer-32,
      handler_type::binary-4,
      reserved1::integer-32,
      reserved2::integer-32,
      reserved3::integer-32,
      rest::binary
    >> = IO.binread(file, size)

    %Hdlr{
      predefined: predefined,
      handler_type: handler_type,
      reserved: [reserved1, reserved2, reserved3],
      # - 1 to remove null byte from the string
      handler_name: binary_part(rest, 0, byte_size(rest) - 1)
    }
  end
end
