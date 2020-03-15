defmodule Mdat do
  defstruct(data: nil)
end

defimpl Box, for: Mdat do
  def parse(_, file, size) do
    :file.position(file, {:cur, size - 8})
    %Mdat{}
  end
end
