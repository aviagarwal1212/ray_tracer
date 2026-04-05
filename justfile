functional_run:
	mix run -e 'RayTracer.functional_run()' > image.ppm

imperative_run:
	mix run -e 'RayTracer.imperative_run()' > image.ppm

flow_run:
	mix run -e 'RayTracer.flow_run()' > image.ppm

compile:
	mix compile

default: compile functional_run

benchmark:
	hyperfine --warmup 3 --show-output 'just imperative_run' 'just functional_run' 'just flow_run'


