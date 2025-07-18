defmodule RayTracer do
  @aspect_ratio 16.0 / 9.0
  @image_width 400

  import Camera

  def run() do
    image = get_image()

    camera =
      new_camera(image)
      |> add_viewport()
      |> add_pixel_delta(image)
      |> add_origin_pixel()

    header =
      """
      P3
      #{image.width} #{image.height}
      255
      """

    IO.puts(:stderr, "Starting render!")
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

  defp get_image() do
    unadjusted_image_height = trunc(@image_width / @aspect_ratio)
    image_height = if unadjusted_image_height < 1, do: 1, else: unadjusted_image_height

    %{width: @image_width, height: image_height}
  end

  defp pixel_color(camera, i, j) do
    pixel_center =
      camera.origin_pixel
      |> Vector.add(Vector.mul(camera.pixel_delta.u, i))
      |> Vector.add(Vector.mul(camera.pixel_delta.v, j))

    ray_direction = Vector.sub(pixel_center, camera.center)
    ray = Ray.new(camera.center, ray_direction)

    ray_color(ray)
  end

  defp ray_color(ray) do
    unit_direction = Vector.unit_vector(ray.dir)
    alpha = 0.5 * (unit_direction.y + 1.0)

    # Vector.mul(Vector.new(1.0, 1.0, 1.0), 1 - alpha)
    # |> Vector.add(Vector.mul(Vector.new(0.5, 0.7, 1.0), alpha))

    Vector.new(1.0, 1.0, 1.0)
    |> Vector.mul(1 - alpha)
    |> Vector.add(Vector.new(0.5, 0.7, 1.0) |> Vector.mul(alpha))
  end
end
