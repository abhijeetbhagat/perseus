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
    IO.puts("Path: #{path}")

    with {:ok, file} = File.open(path) do
      <<length::integer-32, atom_type::binary-4>> = IO.binread(file, 8)
      IO.puts("length: #{length} atom: #{atom_type}")
      IO.puts(inspect(FTyp.parse_ftyp(file, length)))
    end
  end
end
