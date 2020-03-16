defmodule Dinf do
  defstruct(
    name: :dinf,
    data: nil
  )
end

defimpl Box, for: Dinf do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Dinf{}
  end
end
