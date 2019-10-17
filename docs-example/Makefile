# Seek out all plantuml files and generate a SVG
# this is also done during PR by a github action so it is up to you whether
# to generate the SVG by hand.
docs:
	docker run --rm -i -v $(PWD):/work -w /work miy4/plantuml '**/*.puml' -tsvg
