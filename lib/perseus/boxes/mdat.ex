require Logger

defmodule Perseus.Boxes.Mdat do
  defstruct(name: :mdat, data: nil)
end


alias Perseus.Boxes.Mdat

defimpl Perseus.Box, for: Mdat do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Mdat{}
  end
end
