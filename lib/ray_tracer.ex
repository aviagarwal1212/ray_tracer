defmodule RayTracer do
  import Camera

  @aspect_ratio 16.0 / 9.0
  @image_width 400

  def imperative_run() do
    image = get_image()

    new_camera(image)
    |> add_viewport()
    |> add_pixel_delta()
    |> add_origin_pixel()
    |> imperative_render()
  end

  def functional_run() do
    image = get_image()

    new_camera(image)
    |> add_viewport()
    |> add_pixel_delta()
    |> add_origin_pixel()
    |> functional_render()
    |> IO.puts()
  end

  defp get_image() do
    unadjusted_image_height = trunc(@image_width / @aspect_ratio)
    image_height = if unadjusted_image_height < 1, do: 1, else: unadjusted_image_height

    %{width: @image_width, height: image_height}
  end
end
