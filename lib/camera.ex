defmodule Camera do
  defstruct [
    :width,
    :height,
    :center,
    :focal_length,
    :image,
    :viewport,
    :pixel_delta,
    :origin_pixel
  ]

  def new_camera(image, focal_length \\ 1.0, viewport_height \\ 2.0) do
    viewport_width = viewport_height * image.width / image.height

    %Camera{
      width: viewport_width,
      height: viewport_height,
      center: Vector.new(),
      focal_length: focal_length,
      image: image
    }
  end

  def add_viewport(%Camera{width: width, height: height} = camera) do
    %{
      camera
      | viewport: %{
          u: Vector.new(width, 0, 0),
          v: Vector.new(0, -height, 0)
        }
    }
  end

  def add_pixel_delta(%Camera{viewport: %{u: viewport_u, v: viewport_v}, image: image} = camera) do
    %{
      camera
      | pixel_delta: %{
          u: Vector.div(viewport_u, image.width),
          v: Vector.div(viewport_v, image.height)
        }
    }
  end

  def add_origin_pixel(%Camera{pixel_delta: pixel_delta, viewport: viewport} = camera) do
    average_pixel_delta = Vector.add(pixel_delta.u, pixel_delta.v) |> Vector.mul(0.5)

    origin_pixel =
      camera.center
      |> Vector.sub(Vector.new(0, 0, camera.focal_length))
      |> Vector.sub(Vector.div(viewport.u, 2))
      |> Vector.sub(Vector.div(viewport.v, 2))
      |> Vector.add(average_pixel_delta)

    %{camera | origin_pixel: origin_pixel}
  end

  def render(%Camera{image: image} = camera) do
    header =
      """
      P3
      #{image.width} #{image.height}
      255
      """

    IO.puts(:stderr, "Starting render")
    IO.puts(header)

    for j <- 0..(image.height - 1) do
      IO.puts(:stderr, "Scanlines remaining: #{image.height - j}/#{image.height}")

      for i <- 0..(image.width - 1) do
        pixel_color(camera, i, j)
        |> Color.write_color()
      end
    end

    IO.puts(:stderr, "Render complete!")
  end

  defp pixel_color(%Camera{origin_pixel: origin, pixel_delta: pixel_delta, center: center}, i, j) do
    pixel_center =
      origin
      |> Vector.add(Vector.mul(pixel_delta.u, i))
      |> Vector.add(Vector.mul(pixel_delta.v, j))

    ray_direction = Vector.sub(pixel_center, center)

    Ray.new(center, ray_direction)
    |> Ray.color()
  end
end
