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
end
