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
  Calculates the color for a ray.

  Returns red if the ray hits a sphere centered at (0, 0, -1) with radius 0.5.
  Otherwise, creates a sky gradient using linear interpolation between white and
  light blue based on the y-component of the ray's normalized direction vector.

  ## Parameters
  - ray: A Ray struct

  ## Returns
  A Vector representing the RGB color values (0.0 to 1.0 range)
  """
  def color(%Ray{dir: dir} = ray) do
    if hit_sphere(Vector.new(0, 0, -1), 0.5, ray) do
      # red
      Vector.new(1, 0, 0)
    else
      %Vector{y: y} = Vector.unit_vector(dir)
      alpha = 0.5 * (y + 1.0)

      Vector.new(1.0, 1.0, 1.0)
      |> Vector.mul(1 - alpha)
      |> Vector.add(Vector.new(0.5, 0.7, 1.0) |> Vector.mul(alpha))
    end
  end

  # check to see if a ray hits the sphere (one or two intersections)
  defp hit_sphere(%Vector{} = center, radius, %Ray{origin: origin, dir: dir}) do
    oc = Vector.sub(origin, center)
    a = Vector.dot(dir, dir)
    b = 2.0 * Vector.dot(oc, dir)
    c = Vector.dot(oc, oc) - radius * radius
    discriminant = b * b - 4 * a * c
    discriminant >= 0
  end
end
