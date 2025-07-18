defmodule Camera do
  def new_camera(image, focal_length \\ 1.0, viewport_height \\ 2.0) do
    viewport_width = viewport_height * image.width / image.height

    %{
      width: viewport_width,
      height: viewport_height,
      center: Vector.new(),
      focal_length: focal_length
    }
  end

  def add_viewport(%{width: width, height: height} = camera) do
    Map.put(camera, :viewport, %{
      u: Vector.new(width, 0, 0),
      v: Vector.new(0, -height, 0)
    })
  end

  def add_pixel_delta(%{viewport: %{u: viewport_u, v: viewport_v}} = camera, image) do
    Map.put(camera, :pixel_delta, %{
      u: Vector.div(viewport_u, image.width),
      v: Vector.div(viewport_v, image.height)
    })
  end

  def add_origin_pixel(%{pixel_delta: pixel_delta, viewport: viewport} = camera) do
    average_pixel_delta = Vector.add(pixel_delta.u, pixel_delta.v) |> Vector.mul(0.5)

    origin_pixel =
      camera.center
      |> Vector.sub(Vector.new(0, 0, camera.focal_length))
      |> Vector.sub(Vector.div(viewport.u, 2))
      |> Vector.sub(Vector.div(viewport.v, 2))
      |> Vector.add(average_pixel_delta)

    Map.put(camera, :origin_pixel, origin_pixel)
  end
end
