.PHONY: install clean

resume.pdf: resume.tex
	lualatex --interaction=nonstopmode $<

install: resume.pdf
	install -Dm0644 $< $(out)

clean:
	rm -f *.aux *.log *.out *.pdf
