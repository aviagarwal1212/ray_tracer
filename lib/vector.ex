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

  @doc """
  Negates a vector by reversing the sign of all its components.
  
  ## Parameters
  - vector: A Vector struct
  
  ## Returns
  A new Vector with negated x, y, and z components
  """
  def neg(%Vector{x: x, y: y, z: z} = _vector) do
    new(-x, -y, -z)
  end

  @doc """
  Adds two vectors component-wise.
  
  ## Parameters
  - left: A Vector struct
  - right: A Vector struct
  
  ## Returns
  A new Vector representing the sum of the two input vectors
  """
  def add(%Vector{} = left, %Vector{} = right) do
    new(left.x + right.x, left.y + right.y, left.z + right.z)
  end

  @doc """
  Subtracts the right vector from the left vector.
  
  ## Parameters
  - left: A Vector struct (minuend)
  - right: A Vector struct (subtrahend)
  
  ## Returns
  A new Vector representing the difference (left - right)
  """
  def sub(%Vector{} = left, %Vector{} = right) do
    add(left, neg(right))
  end

  @doc """
  Multiplies a vector by a scalar or performs component-wise multiplication of two vectors.
  
  ## Parameters
  - vector: A Vector struct
  - scalar: A number to multiply each component by
  
  OR
  
  - left: A Vector struct
  - right: A Vector struct
  
  ## Returns
  A new Vector with scaled components or component-wise multiplication result
  """
  def mul(%Vector{} = vector, scalar) when is_number(scalar) do
    new(vector.x * scalar, vector.y * scalar, vector.z * scalar)
  end

  def mul(scalar, %Vector{} = vector) when is_number(scalar) do
    mul(vector, scalar)
  end

  def mul(%Vector{} = left, %Vector{} = right) do
    new(left.x * right.x, left.y * right.y, left.z * right.z)
  end

  @doc """
  Divides a vector by a scalar value.
  
  ## Parameters
  - vector: A Vector struct
  - scalar: A number to divide each component by
  
  ## Returns
  A new Vector with each component divided by the scalar
  """
  def div(%Vector{} = vector, scalar) do
    mul(vector, 1 / scalar)
  end

  @doc """
  Computes the dot product of two vectors.
  
  ## Parameters
  - left: A Vector struct
  - right: A Vector struct
  
  ## Returns
  A number representing the dot product (scalar value)
  """
  def dot(%Vector{} = left, %Vector{} = right) do
    left.x * right.x + left.y * right.y + left.z * right.z
  end

  @doc """
  Computes the cross product of two vectors.
  
  ## Parameters
  - left: A Vector struct
  - right: A Vector struct
  
  ## Returns
  A new Vector representing the cross product, perpendicular to both input vectors
  """
  def cross(%Vector{} = left, %Vector{} = right) do
    new(
      left.y * right.z - left.z * right.y,
      left.z * right.x - left.x * right.z,
      left.x * right.y - left.y * right.x
    )
  end

  @doc """
  Calculates the length (magnitude) of a vector.
  
  ## Parameters
  - vector: A Vector struct
  
  ## Returns
  A number representing the Euclidean length of the vector
  """
  def length(%Vector{x: x, y: y, z: z} = _vector) do
    :math.sqrt(x * x + y * y + z * z)
  end

  @doc """
  Converts a vector to a unit vector (normalized vector with length 1).
  
  ## Parameters
  - vector: A Vector struct
  
  ## Returns
  A new Vector with the same direction but length 1
  """
  def unit_vector(%Vector{} = vector) do
    Vector.div(vector, Vector.length(vector))
  end

  defimpl String.Chars, for: Vector do
    def to_string(%Vector{x: x, y: y, z: z}) do
      "#{trunc(x)} #{trunc(y)} #{trunc(z)}"
    end
  end
end
