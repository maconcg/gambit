default: info html-monolith txt

html-phonies := html html-modules html-monolith html-pristine-modules \
 html-pristine-monolith html-css-modules html-css-monolith html-parens-modules \
 html-parens-monolith html-css-modules html-css-monolith \
 html-css-parens-modules html-css-parens-monolith html-css-color-modules \
 html-css-color-monolith

.PHONY: default all all-html html-all clean clean-intermediate mostlyclean \
        info txt ${html-phonies}

all: info all-html txt

all-html html-all: ${html-phonies}

clean: clean-intermediate
	rm -fr html/ html-parens/ html-css/ html-css-parens/
	rm -f gambit.info gambit.txt gambit.html gambit-parens.html \
		gambit-css.html gambit-css-parens.html

mostlyclean clean-intermediate:
	rm -fr html-pristine/ html-css-color/ html-css-color-parens/ procedures/c
	rm -f gambit.incolor.txi gambit-pristine.html gambit-css-color.html \
		gambit-css-color-parens.html toolshed/gambit.css \
		toolshed/colorize.sed

gambit.txi: body/* procedures/*.txi toolshed/*.t*
	touch $@

info: gambit.info
gambit.info: gambit.txi
	texi2any -o $@ --info --no-split gambit.txi

txt: gambit.txt
gambit.txt: gambit.txi
	texi2any -o $@ --plaintext gambit.txi

html: html-monolith
html-monolith: gambit.html
gambit.html: gambit-css-color-parens.html
	ln -f gambit-css-color-parens.html $@

html-modules: html/.stamp
html/.stamp: html-css-color-parens/.stamp
	test -d html/ || mkdir html/
	for f in html-css-color-parens/*.html html-css-color/*.css; do\
		ln -f "$$f" html/"$${f#*/}";\
	done
	touch $@

html-pristine-monolith: gambit-pristine.html
gambit-pristine.html: gambit.txi toolshed/gambit.css
	texi2any -o $@ --html --no-split gambit.txi

html-parens-monolith: gambit-parens.html
gambit-parens.html: gambit-pristine.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gambit-pristine.html > $@

html-css-monolith: gambit-css.html
gambit-css.html: gambit.txi toolshed/gambit.css
	texi2any -o $@ --html --css-include=toolshed/gambit.css --no-split \
		gambit.txi

html-css-parens-monolith: gambit-css-parens.html
gambit-css-parens.html: gambit-css.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gambit-css.html > $@

html-css-color-monolith: gambit-css-color.html
gambit-css-color.html: gambit.incolor.txi toolshed/gambit.css
	texi2any -o $@ --html --css-include=toolshed/gambit.css --no-split \
		gambit.incolor.txi

html-css-color-parens-monolith: gambit-css-color-parens.html
gambit-css-color-parens.html: gambit-css-color.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gambit-css-color.html > $@

gambit.incolor.txi: gambit.txi procedures/c/.stamp
	sed '/^@include/s/ procedures\// procedures\/c\//' gambit.txi > $@

toolshed/colorize.sed: toolshed/colorize.sed.sh toolshed/keywords/syntax
	sh -efu toolshed/colorize.sed.sh > $@

procedures/c/.stamp: procedures/c/pairs-lists.txi \
                     procedures/c/strings.txi
	touch $@

procedures/c/pairs-lists.txi: procedures/pairs-lists.txi toolshed/colorize.sed
	test -d procedures/c || mkdir procedures/c
	sed -f toolshed/colorize.sed procedures/pairs-lists.txi > $@

procedures/c/strings.txi: procedures/strings.txi toolshed/colorize.sed
	test -d procedures/c || mkdir procedures/c
	sed -f toolshed/colorize.sed procedures/strings.txi > $@

toolshed/gambit.css: toolshed/gambit.css.in toolshed/make-css.sh
	sh -efu toolshed/make-css.sh toolshed/gambit.css.in > $@

html-pristine-modules: html-pristine/.stamp
html-pristine/.stamp: gambit.txi
	texi2any -o html-pristine --html gambit.txi
	touch $@

html-parens-modules: html-parens/.stamp
html-parens/.stamp: html-pristine/.stamp toolshed/parenthesize-defs.sed
	test -d html-parens/ || mkdir html-parens/
	for h in html-pristine/*.html; do\
		sed -f toolshed/parenthesize-defs.sed "$$h"\
			> html-parens/"$${h#*/}";\
	done
	touch $@

html-css-modules: html-css/.stamp
html-css/.stamp: gambit.txi toolshed/gambit.css
	texi2any -o html-css --html --css-ref=gambit.css gambit.txi
	cp toolshed/gambit.css html-css/gambit.css
	touch $@

html-css-color-modules: html-css-color/.stamp
html-css-color/.stamp: gambit.incolor.txi toolshed/gambit.css
	texi2any -o html-css-color --html --css-ref=gambit.css gambit.incolor.txi
	cp toolshed/gambit.css html-css-color/gambit.css
	touch $@

html-css-parens-modules: html-css-parens/.stamp
html-css-parens/.stamp: html-css/.stamp toolshed/parenthesize-defs.sed
	test -d html-css-parens/ || mkdir html-css-parens/
	for h in html-css/*.html; do\
		sed -f toolshed/parenthesize-defs.sed "$$h"\
			> html-css-parens/"$${h#*/}";\
	done
	cp html-css/*.css html-css-parens/
	touch $@

html-css-color-parens-modules: html-css-color-parens/.stamp
html-css-color-parens/.stamp: html-css-color/.stamp toolshed/parenthesize-defs.sed
	test -d html-css-color-parens/ || mkdir html-css-color-parens/
	for h in html-css-color/*.html; do\
		sed -f toolshed/parenthesize-defs.sed "$$h"\
			> html-css-color-parens/"$${h#*/}";\
	done
	cp html-css-color/*.css html-css-color-parens/
	touch $@
