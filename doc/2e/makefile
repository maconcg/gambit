gambit-css := toolshed/gambit.css
css-arg := --css-include=${gambit-css}
html-sources := gambit.txi ${gambit-css}
make-css := toolshed/make-css.sh

html-modules-dir := gambit-html

default: html info txt

.PHONY: clean default html html-modules html-monolith info txt

clean:
	rm -fr ${html-modules-dir}/ ${gambit-css} gambit.{html,info,txt}

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
	texi2any -o $@ --plaintext gambit.txi

${gambit-css}: ${gambit-css}.in ${make-css}
	sh ${make-css} ${gambit-css}.in > $@
