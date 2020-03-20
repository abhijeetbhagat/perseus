defprotocol Perseus.Box do
  @moduledoc """
  The `Perseus.Box` protocol should be implemented
  by all the boxes.
  """

  @doc """
  Parse box content. Accepts the implementing struct, `io_device` and box length
  """
  def parse(box, file, length)
end
