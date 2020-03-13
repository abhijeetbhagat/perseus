defmodule Perseus do
  @moduledoc """
  Documentation for `Perseus`.
  """

  @spec get_meta(
          binary
          | maybe_improper_list(
              binary | maybe_improper_list(any, binary | []) | char,
              binary | []
            )
        ) :: :ok
  @doc """
  Hello world.

  ## Examples

      iex> Perseus.get_meta(~S(C:\Users\abhagat\code\mp4box\test\output_squirrel.mp4))
      :world

  """
  def get_meta(path) do
    Parser.parse(path)
  end
end
