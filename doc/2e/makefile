texinfo-sources := gambit.txi body/* procedures/* toolshed/*.t*
html-sources := ${texinfo-sources} toolshed/*.css
html-modules-dir := gambit-html

default: html info txt

.PHONY: clean default html html-monolith info txt

clean:
	rm -fr ${html-modules-dir}/ gambit.html gambit.info gambit.txt

html: html-modules html-monolith

html-modules: ${html-modules-dir}/.stamp

html-monolith: gambit.html

info: gambit.info

txt: gambit.txt

${html-modules-dir}/.stamp: ${html-sources}
	texi2any -o ${html-modules-dir}/ --html gambit.txi && touch $@

gambit.html: ${html-sources}
	texi2any -o $@ --html --no-split gambit.txi

gambit.info: ${texinfo-sources}
	texi2any -o $@ --info --no-split gambit.txi

gambit.txt: ${texinfo-sources}
	texi2any --plaintext -o $@ gambit.txi
