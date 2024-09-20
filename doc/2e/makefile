html-sources := gambit.txi toolshed/gambit.css
html-modules-dir := gambit-html
css-arg := --css-include=toolshed/gambit.css

default: html info txt

.PHONY: clean default html html-monolith info txt

clean:
	rm -fr ${html-modules-dir}/ gambit.html gambit.info gambit.txt

gambit.txi: body/* procedures/* toolshed/*.t*
	touch $@

html: html-modules html-monolith

html-modules: ${html-modules-dir}/.stamp

html-monolith: gambit.html

info: gambit.info

txt: gambit.txt

${html-modules-dir}/.stamp: ${html-sources}
	texi2any -o ${html-modules-dir}/ --html ${css-arg} gambit.txi
	touch $@

gambit.html: ${html-sources}
	texi2any -o $@ --html ${css-arg} --no-split gambit.txi

gambit.info: gambit.txi
	texi2any -o $@ --info --no-split gambit.txi

gambit.txt: gambit.txi
	texi2any --plaintext -o $@ gambit.txi
