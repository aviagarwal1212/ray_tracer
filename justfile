functional_run:
    mix run -e "RayTracer.functional_run()" > image.ppm

imperative_run:
    mix run -e "RayTracer.imperative_run()" > new_image.ppm

run:
    mix compile; just functional_run
