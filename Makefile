.PHONY: install clean

all: resume.pdf

%.pdf: %.tex
	lualatex --interaction=nonstopmode $<

install: resume.pdf
	install -Dm0644 $< $(out)

clean:
	rm -f *.aux *.log *.out *.pdf
