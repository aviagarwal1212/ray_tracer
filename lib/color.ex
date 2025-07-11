defmodule Color do
  def write_color(%Vector{x: x, y: y, z: z}, device \\ :stdio) do
    [rbyte, gbyte, bbyte] = [x, y, z] |> Enum.map(&to_byte_range/1)

    IO.puts(device, "#{rbyte} #{gbyte} #{bbyte}")
  end

  defp to_byte_range(component_value), do: trunc(255.999 * component_value)
end
