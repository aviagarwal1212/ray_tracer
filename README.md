# RayTracer

A ray tracer written in Elixir, following [_Ray Tracing in One Weekend_](https://raytracing.github.io/). Renders scenes to PPM image files.

## Usage

Tasks are managed with [mise](https://mise.jdx.dev/).

```bash
mise run functional_run    # render using Stream.map, outputs image.ppm
mise run imperative_run    # render using for loops, outputs new_image.ppm
mise run flow_run          # render using Flow (parallel across all cores), outputs flow_image.ppm
mise run run               # compile then functional_run
mise run benchmark_render  # benchmark all three render strategies with hyperfine
```

## Architecture

| Module      | Responsibility                                      |
|-------------|-----------------------------------------------------|
| `Vector`    | 3D vector math (add, dot, cross, normalize, etc.)   |
| `Ray`       | Ray representation, point evaluation, and coloring  |
| `Color`     | Converts float RGB vectors to PPM byte format       |
| `Camera`    | Viewport setup and rendering pipeline               |
| `RayTracer` | Entry point, image configuration                    |
