defmodule Vector do
  @moduledoc """
  Vector module for working with vec3
  """

  defstruct x: 0, y: 0, z: 0

  @doc """
  creates a new %Vector{} struct with default values
  """
  def new() do
    %Vector{}
  end

  @doc """
  creates a new %Vector{} struct with specified values of x, y and z
  """
  def new(x, y, z) do
    %Vector{x: x, y: y, z: z}
  end

  # vector utility functions

  def neg(%Vector{x: x, y: y, z: z} = _vector) do
    new(-x, -y, -z)
  end

  def add(%Vector{} = left, %Vector{} = right) do
    new(left.x + right.x, left.y + right.y, left.z + right.z)
  end

  def sub(%Vector{} = left, %Vector{} = right) do
    add(left, neg(right))
  end

  def mul(%Vector{} = vector, scalar) when is_number(scalar) do
    new(vector.x * scalar, vector.y * scalar, vector.z * scalar)
  end

  def mul(scalar, %Vector{} = vector) when is_number(scalar) do
    mul(vector, scalar)
  end

  def mul(%Vector{} = left, %Vector{} = right) do
    new(left.x * right.x, left.y * right.y, left.z * right.z)
  end

  def div(%Vector{} = vector, scalar) do
    mul(vector, 1 / scalar)
  end

  def dot(%Vector{} = left, %Vector{} = right) do
    left.x * right.x + left.y * right.y + left.z * right.z
  end

  def cross(%Vector{} = left, %Vector{} = right) do
    new(
      left.y * right.z - left.z * right.y,
      left.z * right.x - left.x * right.z,
      left.x * right.y - left.y * right.x
    )
  end

  def length(%Vector{x: x, y: y, z: z} = _vector) do
    :math.sqrt(x * x + y * y + z * z)
  end

  def unit_vector(%Vector{} = vector) do
    Vector.div(vector, Vector.length(vector))
  end

  defimpl String.Chars, for: Vector do
    def to_string(%Vector{x: x, y: y, z: z}) do
      "#{trunc(x)} #{trunc(y)} #{trunc(z)}"
    end
  end
end
