defmodule Camera do
  @moduledoc """
  Camera module for ray tracing, handling viewport setup and rendering.
  """

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

  @doc """
  Creates a new Camera struct with specified parameters.

  ## Parameters
  - image: A map containing width and height of the image
  - focal_length: Distance from camera center to viewport (default: 1.0)
  - viewport_height: Height of the viewport in world units (default: 2.0)

  ## Returns
  A new %Camera{} struct with calculated viewport dimensions
  """
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

  @doc """
  Adds viewport vectors to the camera configuration.

  Creates horizontal (u) and vertical (v) vectors that define the viewport's
  coordinate system in 3D space.

  ## Parameters
  - camera: A Camera struct

  ## Returns
  Updated Camera struct with viewport u and v vectors
  """
  def add_viewport(%Camera{width: width, height: height} = camera) do
    %{
      camera
      | viewport: %{
          u: Vector.new(width, 0, 0),
          v: Vector.new(0, -height, 0)
        }
    }
  end

  @doc """
  Calculates pixel delta vectors for stepping through the viewport.

  These vectors represent the offset from one pixel to the next in both
  horizontal and vertical directions.

  ## Parameters
  - camera: A Camera struct with viewport information

  ## Returns
  Updated Camera struct with pixel delta u and v vectors
  """
  def add_pixel_delta(%Camera{viewport: %{u: viewport_u, v: viewport_v}, image: image} = camera) do
    %{
      camera
      | pixel_delta: %{
          u: Vector.div(viewport_u, image.width),
          v: Vector.div(viewport_v, image.height)
        }
    }
  end

  @doc """
  Calculates the position of the upper-left pixel in the viewport.

  This establishes the starting point for ray casting through the image.

  ## Parameters
  - camera: A Camera struct with pixel_delta and viewport information

  ## Returns
  Updated Camera struct with the origin_pixel position
  """
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

  @doc """
  Renders the image using imperative loops and outputs directly to stdout.

  Uses nested for loops to iterate through each pixel and outputs the PPM format.

  ## Parameters
  - camera: A fully configured Camera struct

  ## Returns
  :ok (outputs directly to stdout)
  """
  def imperative_render(%Camera{image: image} = camera) do
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
        |> IO.puts()
      end
    end

    IO.puts(:stderr, "Render complete!")
  end

  @doc """
  Renders the image using functional programming constructs and returns the result.

  Uses Stream.map for lazy evaluation and returns the complete PPM string.

  ## Parameters
  - camera: A fully configured Camera struct

  ## Returns
  A string containing the complete PPM format image data
  """
  def functional_render(%Camera{image: image} = camera) do
    header =
      """
      P3
      #{image.width} #{image.height}
      255
      """

    IO.puts(:stderr, "Starting render")

    data =
      0..(image.height - 1)
      |> Stream.map(fn j ->
        IO.puts(:stderr, "Scanlines remaining: #{image.height - j}/#{image.height}")

        row_data =
          0..(image.width - 1)
          |> Stream.map(fn i ->
            pixel_color(camera, i, j)
            |> Color.write_color()
          end)
          |> Enum.to_list()
          |> Enum.join()

        row_data
      end)
      |> Enum.to_list()
      |> Enum.join()

    data = header <> data

    IO.puts(:stderr, "Render complete!")
    data
  end

  # Calculates the color for a specific pixel in the image.
  #
  # Computes the pixel's center position in world space, creates a ray from the camera
  # center through that pixel, and determines the resulting color.
  #
  # Parameters:
  # - camera: A Camera struct with all viewport calculations completed
  # - i: The horizontal pixel index (0-based from left)
  # - j: The vertical pixel index (0-based from top)
  #
  # Returns: A Vector representing the RGB color values for this pixel
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
