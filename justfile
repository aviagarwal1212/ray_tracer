default: compile functional_run open

functional_run:
	mix run -e 'RayTracer.functional_run()' > output/image.ppm

imperative_run:
	mix run -e 'RayTracer.imperative_run()' > output/image.ppm

flow_run:
	mix run -e 'RayTracer.flow_run()' > output/image.ppm

compile:
	mix compile

open:
	open output/image.ppm

benchmark:
	hyperfine --warmup 3 --show-output 'just imperative_run' 'just functional_run' 'just flow_run'




