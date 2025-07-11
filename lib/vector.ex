defmodule Vector do
  @moduledoc """
  Vector module for working with vec3 (3-Vectors)
  """

  defstruct x: 0, y: 0, z: 0

  def new() do
    %__MODULE__{}
  end

  def new(x, y, z) do
    %__MODULE__{x: x, y: y, z: z}
  end

  def neg(%__MODULE__{x: x, y: y, z: z} = _vector) do
    new(-x, -y, -z)
  end

  def add(%__MODULE__{} = left, %__MODULE__{} = right) do
    new(left.x + right.x, left.y + right.y, left.z + right.z)
  end

  def sub(%__MODULE__{} = left, %__MODULE__{} = right) do
    add(left, neg(right))
  end

  def mul(%__MODULE__{} = vector, scalar) when is_number(scalar) do
    new(vector.x * scalar, vector.y * scalar, vector.z * scalar)
  end

  def mul(scalar, %__MODULE__{} = vector) when is_number(scalar) do
    mul(vector, scalar)
  end

  def mul(%__MODULE__{} = left, %__MODULE__{} = right) do
    new(left.x * right.x, left.y * right.y, left.z * right.z)
  end

  def div(%__MODULE__{} = vector, scalar) do
    mul(vector, 1 / scalar)
  end

  def dot(%__MODULE__{} = left, %__MODULE__{} = right) do
    left.x * right.x + left.y * right.y + left.z * right.z
  end

  def cross(%__MODULE__{} = left, %__MODULE__{} = right) do
    new(
      left.y * right.z - left.z * right.y,
      left.z * right.x - left.x * right.z,
      left.x * right.y - left.y * right.x
    )
  end

  def length(%__MODULE__{x: x, y: y, z: z} = _vector) do
    :math.sqrt(x * x + y * y + z * z)
  end

  def unit_vector(%__MODULE__{} = vector) do
    __MODULE__.div(vector, __MODULE__.length(vector))
  end

  defimpl String.Chars, for: __MODULE__ do
    def to_string(vector) do
      "#{vector.x} #{vector.y} #{vector.z}"
    end
  end
end
