require Logger

defmodule Mdat do
  defstruct(name: :mdat, data: nil)
end

defimpl Box, for: Mdat do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Mdat{}
  end
end
