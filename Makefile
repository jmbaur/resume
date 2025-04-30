.PHONY: clean

resume.pdf: resume.tex
	latexmk -pdf $<

clean:
	rm -f *.aux *.fls *.out *.fdb_latexmk *.log *.pdf
