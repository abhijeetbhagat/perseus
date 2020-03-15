defmodule Udta do
  defstruct(
    name: :udta,
    data: nil
  )
end

defimpl Box, for: Udta do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Udta{}
  end
end
