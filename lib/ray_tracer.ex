defmodule RayTracer do
  require Logger

  @image_width 256
  @image_height 256

  def render_image() do
    create_image_data() |> Enum.join("\n") |> IO.puts()
  end

  def create_image_data() do
    data = outer_loop([], 0, 0) |> Enum.reverse()
    preamble = "P3\n#{@image_width} #{@image_height}\n255"

    [preamble | data]
  end

  def outer_loop(data, _i, @image_height) do
    data
  end

  def outer_loop(data, i, j) do
    IO.puts(:stderr, "Scanlines remaining: #{@image_height - j}/#{@image_height}")
    data = inner_loop(data, i, j)
    outer_loop(data, i, j + 1)
  end

  def inner_loop(data, @image_width, _j) do
    data
  end

  def inner_loop(data, i, j) do
    line = calculate_pixels(i, j)
    inner_loop([line | data], i + 1, j)
  end

  def calculate_pixels(i, j) do
    ir = (255.99 * i / (@image_width - 1)) |> trunc()
    ig = (255.99 * j / (@image_height - 1)) |> trunc()
    "#{ir} #{ig} 0"
  end

  def write_to_file(data) do
    File.write("image.ppm", data)
  end
end
