defmodule Iods do
  defstruct(
    name: :iods,
    data: nil
  )
end

defimpl Box, for: Iods do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Iods{}
  end
end
