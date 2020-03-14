defmodule Iods do
  defstruct data: nil
end

defimpl Box, for: Iods do
  def parse(_, file, size) do
    :file.position(file, {:cur, size - 8})
    %Iods{}
  end
end
