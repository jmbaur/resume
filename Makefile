.PHONY: clean

resume.pdf: resume.tex
	lualatex --interaction=nonstopmode $<

clean:
	rm -f *.aux *.log *.out *.pdf
