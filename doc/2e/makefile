gambit-css := toolshed/gambit.css
css-arg := --css-include=${gambit-css}
html-sources := gambit.txi ${gambit-css}
make-css := toolshed/make-css.sh
parenthesize := toolshed/parenthesize.sed

html-modules-dir := gambit-html
html-modules-np-dir := gambit-html-np

default: html info txt

.PHONY: clean default html html-modules html-modules-np html-modules-p  \
 html-monolith html-monolith-np html-monolith-p info txt

clean:
	rm -fr ${html-modules-dir}/ ${html-modules-np-dir}/ \
		${gambit-css} gambit.{html,info,txt}

gambit.txi: body/* procedures/* toolshed/*.t*
	touch $@

html: html-modules html-monolith

html-modules: html-modules-p

html-modules-p: ${html-modules-dir}/.stamp

html-modules-np: ${html-modules-np-dir}/.stamp

html-monolith: html-monolith-p

html-monolith-p: gambit.html

html-monolith-np: gambit-np.html

info: gambit.info

txt: gambit.txt

${html-modules-np-dir}/.stamp: ${html-sources}
	mkdir -p ${html-modules-np-dir}
	texi2any -o ${html-modules-np-dir}/ --html ${css-arg} gambit.txi
	touch $@

${html-modules-dir}/.stamp: ${html-modules-np-dir}/.stamp ${parenthesize}
	mkdir -p ${html-modules-dir}
	for h in ${html-modules-np-dir}/*.html; do\
		sed -f ${parenthesize} "$$h" > ${html-modules-dir}/"$${h#*/}";\
	done
	touch $@

gambit-np.html: ${html-sources}
	texi2any -o $@ --html ${css-arg} --no-split gambit.txi

gambit.html: gambit-np.html ${parenthesize}
	sed -f ${parenthesize} gambit-np.html > $@

gambit.info: gambit.txi
	texi2any -o $@ --info --no-split gambit.txi

gambit.txt: gambit.txi
	texi2any -o $@ --plaintext gambit.txi

${gambit-css}: ${gambit-css}.in ${make-css}
	sh ${make-css} ${gambit-css}.in > $@
