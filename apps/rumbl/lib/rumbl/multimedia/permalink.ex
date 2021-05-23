defmodule Rumbl.Multimedia.Permalink do
  @behaviour Ecto.Type

  def type, do: :binary_id

  def cast(binary) when is_binary(binary) do
    {:ok, String.slice(binary, 0, 36)}
  end

  def cast(_) do
    :error
  end

  def dump(binary) when is_binary(binary) do
    {:ok, binary}
  end

  def load(binary) when is_binary(binary) do
    {:ok, binary}
  end
end
