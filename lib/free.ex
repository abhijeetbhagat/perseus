defmodule Free do
  defstruct(
    name: :free,
    data: nil
  )
end

defimpl Box, for: Free do
  def parse(_, file, size) do
    :file.position(file, {:cur, size - 8})
    %Free{}
  end
end
