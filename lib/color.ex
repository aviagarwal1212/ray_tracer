defmodule Color do
  @moduledoc """
  Color module to interpret Vector structs as colors
  """

  @doc """
  utility function that writes a single pixel's color out to standard output stream
  """
  def write_color(%Vector{x: x, y: y, z: z}) do
    [r_byte, g_byte, b_byte] = [x, y, z] |> Enum.map(&to_byte_range/1)

    "#{r_byte} #{g_byte} #{b_byte}\n"
  end

  # Converts a color component value from [0, 1] range to byte range [0, 255].
  #
  # Uses 255.999 instead of 256 to ensure that a value of exactly 1.0
  # maps to 255 rather than 256 (which would overflow the byte range).
  #
  # Parameters:
  # - component_value: A float between 0.0 and 1.0 representing a color component
  #
  # Returns: An integer between 0 and 255 suitable for PPM format output
  defp to_byte_range(component_value), do: trunc(255.999 * component_value)
end
