defmodule Ray do
  defstruct [:origin, :dir]

  def new(%Vector{} = origin_vector, %Vector{} = direction_vector) do
    %Ray{origin: origin_vector, dir: direction_vector}
  end

  def at(%Ray{origin: origin, dir: dir}, ray_parameter) do
    dir
    |> Vector.mul(ray_parameter)
    |> Vector.add(origin)
  end

  def color(%Ray{dir: dir}) do
    %Vector{y: y} = Vector.unit_vector(dir)
    alpha = 0.5 * (y + 1.0)

    Vector.new(1.0, 1.0, 1.0)
    |> Vector.mul(1 - alpha)
    |> Vector.add(Vector.new(0.5, 0.7, 1.0) |> Vector.mul(alpha))
  end
end
