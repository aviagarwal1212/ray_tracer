defmodule Color do
  @moduledoc """
  Color module to interpret Vector structs as colors
  """

  @doc """
  utility function that writes a single pixel's color out to standard output stream
  """
  def write_color(%Vector{x: x, y: y, z: z}, device \\ :stdio) do
    [rbyte, gbyte, bbyte] = [x, y, z] |> Enum.map(&to_byte_range/1)

    IO.puts(device, "#{rbyte} #{gbyte} #{bbyte}")
  end

  # translates [0, 1] component values to byte range [0, 255]
  defp to_byte_range(component_value), do: trunc(255.999 * component_value)
end
