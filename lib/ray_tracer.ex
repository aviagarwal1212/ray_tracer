defmodule RayTracer do
  @moduledoc """
  Main RayTracer module that orchestrates the ray tracing process.
  
  Provides both imperative and functional approaches to rendering.
  """
  
  import Camera

  @aspect_ratio 16.0 / 9.0
  @image_width 400

  @doc """
  Runs the ray tracer using imperative rendering approach.
  
  Sets up the camera and renders the image using nested loops,
  outputting directly to stdout.
  
  ## Returns
  :ok (outputs PPM format to stdout)
  """
  def imperative_run() do
    image = get_image()

    new_camera(image)
    |> add_viewport()
    |> add_pixel_delta()
    |> add_origin_pixel()
    |> imperative_render()
  end

  @doc """
  Runs the ray tracer using functional rendering approach.
  
  Sets up the camera and renders the image using Stream operations,
  returning the complete image data before outputting.
  
  ## Returns
  :ok (outputs PPM format to stdout)
  """
  def functional_run() do
    image = get_image()

    new_camera(image)
    |> add_viewport()
    |> add_pixel_delta()
    |> add_origin_pixel()
    |> functional_render()
    |> IO.puts()
  end

  # Calculates the image dimensions based on the configured aspect ratio and width.
  #
  # Determines the appropriate image height from the aspect ratio and ensures
  # it's at least 1 pixel tall to avoid zero-height images.
  #
  # Returns: A map containing :width and :height keys with the calculated image dimensions
  defp get_image() do
    unadjusted_image_height = trunc(@image_width / @aspect_ratio)
    image_height = if unadjusted_image_height < 1, do: 1, else: unadjusted_image_height

    %{width: @image_width, height: image_height}
  end
end
