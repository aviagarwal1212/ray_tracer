defmodule RayTracer do
  @image_width 256
  @image_height 256

  def run() do
    IO.puts("P3\n#{@image_width} #{@image_height}\n255")

    for j <- 0..(@image_height - 1) do
      IO.puts(:stderr, "Scanlines remaining: #{@image_height - j}/#{@image_height}")

      for i <- 0..(@image_width - 1) do
        Vector.new(i / (@image_width - 1), j / (@image_height - 1), 0)
        |> Color.write_color()
      end
    end

    IO.puts(:stderr, "Render complete!")
  end
end
