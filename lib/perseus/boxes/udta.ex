require Logger

defmodule Perseus.Boxes.Udta do
  defstruct(
    name: :udta,
    data: nil
  )
end

alias Perseus.Boxes.Udta

defimpl Perseus.Box, for: Udta do
  def parse(_, file, size) do
    :file.position(file, {:cur, size})
    %Udta{}
  end
end
