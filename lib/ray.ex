defmodule Ray do
  @moduledoc """
  Ray module for representing a ray in 3D space with an origin point and direction vector.
  """
  
  defstruct [:origin, :dir]

  @doc """
  Creates a new Ray struct with the given origin and direction vectors.
  
  ## Parameters
  - origin_vector: A Vector representing the ray's starting point
  - direction_vector: A Vector representing the ray's direction
  
  ## Returns
  A new %Ray{} struct
  """
  def new(%Vector{} = origin_vector, %Vector{} = direction_vector) do
    %Ray{origin: origin_vector, dir: direction_vector}
  end

  @doc """
  Calculates a point along the ray at a given parameter value.
  
  The formula is: point = origin + t * direction
  
  ## Parameters
  - ray: A Ray struct
  - ray_parameter: A number representing how far along the ray to calculate the point
  
  ## Returns
  A Vector representing the point at the given parameter along the ray
  """
  def at(%Ray{origin: origin, dir: dir}, ray_parameter) do
    dir
    |> Vector.mul(ray_parameter)
    |> Vector.add(origin)
  end

  @doc """
  Calculates the color for a ray based on its direction, creating a sky gradient.
  
  Uses linear interpolation between white and light blue based on the y-component
  of the ray's normalized direction vector.
  
  ## Parameters
  - ray: A Ray struct
  
  ## Returns
  A Vector representing the RGB color values (0.0 to 1.0 range)
  """
  def color(%Ray{dir: dir}) do
    %Vector{y: y} = Vector.unit_vector(dir)
    alpha = 0.5 * (y + 1.0)

    Vector.new(1.0, 1.0, 1.0)
    |> Vector.mul(1 - alpha)
    |> Vector.add(Vector.new(0.5, 0.7, 1.0) |> Vector.mul(alpha))
  end
end
