defmodule RayTracer do
  @aspect_ratio 16.0 / 9.0
  @image_width 400

  def run() do
    camera =
      new_camera()
      |> add_viewport()
      |> add_pixel_delta()
      |> find_origin_pixel()

    IO.puts("P3\n#{@image_width} #{image_height()}\n255")

    for j <- 0..(image_height() - 1) do
      IO.puts(:stderr, "Scanlines remaining: #{image_height() - j}/#{image_height()}")

      for i <- 0..(@image_width - 1) do
        pixel_color(camera, i, j)
        |> Color.write_color()
      end
    end

    IO.puts(:stderr, "Render complete!")
  end

  defp new_camera(focal_length \\ 1.0, viewport_height \\ 2.0) do
    viewport_width = viewport_height * @image_width / image_height()

    %{
      width: viewport_width,
      height: viewport_height,
      center: Vector.new(),
      focal_length: focal_length
    }
  end

  defp add_viewport(camera) do
    Map.put(camera, :viewport, %{
      u: Vector.new(camera.width, 0, 0),
      v: Vector.new(0, -camera.height, 0)
    })
  end

  defp add_pixel_delta(camera) do
    Map.put(camera, :pixel_delta, %{
      u: Vector.div(camera.viewport.u, @image_width),
      v: Vector.div(camera.viewport.v, image_height())
    })
  end

  defp find_origin_pixel(camera) do
    average_pixel_delta =
      Vector.add(camera.pixel_delta.u, camera.pixel_delta.v) |> Vector.mul(0.5)

    origin_pixel =
      camera.center
      |> Vector.sub(Vector.new(0, 0, camera.focal_length))
      |> Vector.sub(Vector.div(camera.viewport.u, 2))
      |> Vector.sub(Vector.div(camera.viewport.v, 2))
      |> Vector.add(average_pixel_delta)

    Map.put(camera, :origin_pixel, origin_pixel)
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

    Vector.mul(Vector.new(1.0, 1.0, 1.0), 1 - alpha)
    |> Vector.add(Vector.mul(Vector.new(0.5, 0.7, 1.0), alpha))
  end

  defp image_height() do
    unadjusted_image_height = trunc(@image_width / @aspect_ratio)

    if unadjusted_image_height < 1, do: 1, else: unadjusted_image_height
  end
end
