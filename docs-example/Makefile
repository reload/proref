# Seek out all plantuml files and generate a png
docs:
	@rm images/*
	@find diagrams/*.plantuml -type f -exec basename -s .plantuml {} \; | xargs -I % bash -c "echo 'diagrams/%.plantuml -> images/%.png' ;cat diagrams/%.plantuml | docker run --rm -i think/plantuml -tpng > images/%.png"
