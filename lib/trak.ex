defmodule Trak do
  defstruct data: nil
end

defimpl Box, for: Trak do
  def parse(_, file, size) do
    :file.position(file, {:cur, size - 8})
    %Trak{}
  end
end
