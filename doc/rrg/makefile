default: gambit.html gambit.info gambit.txt

.PHONY: all clean compile compile-exe default gauntlet highlight

gsc ?= gsc
gsi ?= gsi

SCM ?= examples/gauntlet.scm

clean:
	rm -f *.html *.info gambit.{txi,txt} toolshed/*.css toolshed/*.html\
		toolshed/macros+vars.txi toolshed/scm-to-html \
		toolshed/adorn/adorn.o1
	rm -fr procedures/a/ html-modules/

compile: toolshed/adorn/adorn.o1
compile-exe: toolshed/adorn/adorn.o1 toolshed/scm-to-html

toolshed/scm-to-html: toolshed/scm-to-html.scm toolshed/adorn/adorn.o1
	${gsc} -exe toolshed/scm-to-html.scm

toolshed/adorn/adorn.o1: toolshed/adorn/adorn.sld \
 toolshed/adorn/adornment.scm toolshed/adorn/binding-mesg-handlers.scm \
 toolshed/adorn/char-mesg-handlers.scm \
 toolshed/adorn/comment-mesg-handlers.scm toolshed/adorn/helpers.scm \
 toolshed/adorn/matching.scm toolshed/adorn/numeric-mesg-handlers.scm \
 toolshed/adorn/other-mesg-handlers.scm \
 toolshed/adorn/rt-syntax-handlers.scm \
 toolshed/adorn/symmetric-mesg-handlers.scm
	${gsc} -o $@ toolshed/adorn/adorn

gambit.info: gambit.txi
	texi2any -o $@ --info --no-split gambit.txi

gambit.txt: gambit.txi
	texi2any -o $@ --plaintext gambit.txi

gambit-pristine.html: gambit-pristine.txi toolshed/macros+vars.txi
	texi2any -o $@ --html --no-split gambit.txi

gambit-pristine.txi: toolshed/macros+vars.txi

gambit-css.html: gambit-pristine.txi toolshed/gambit.css
	texi2any -o $@ --html --no-split --css-include=toolshed/gambit.css \
		gambit-pristine.txi

highlight: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	readonly scm=$$(realpath "${SCM}") &&\
	cd toolshed && if test -x scm-to-html; then\
				./scm-to-html -e "$$scm";\
			else\
				${gsi} -f scm-to-html.scm -e "$$scm";\
			fi
	mv toolshed/"$$(basename ${SCM})".html .

toolshed/gambit.css: toolshed/write-css.scm
	cd toolshed && ${gsi} -f write-css.scm > gambit.css

toolshed/gambit-examples.css: toolshed/write-css.scm
	cd toolshed && ${gsi} -f write-css.scm -e > gambit-examples.css

toolshed/gambit-cm.css: toolshed/write-css.scm
	cd toolshed && ${gsi} -f write-css.scm -c > gambit-cm.css

toolshed/gambit-examples-cm.css: toolshed/write-css.scm
	cd toolshed && ${gsi} -f write-css.scm -c -e > gambit-examples-cm.css

toolshed/macros+vars.txi: toolshed/write-macros+vars.scm
	cd toolshed && ${gsi} -f write-macros+vars.scm > macros+vars.txi

gauntlet: gauntlet.scm.html
gauntlet.scm.html: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	cd toolshed && ${gsi} -f scm-to-html.scm -e examples/gauntlet.scm
	mv toolshed/gauntlet.scm.html .

html-deps := gambit.txi procedures/a/pairs-lists.txi procedures/a/strings.txi\
 toolshed/gambit.css toolshed/parenthesize-defs.sed

html-modules: ${html-deps}
	test -d html-modules || mkdir -p html-modules
	readonly tmp=$$(mktemp -d) &&\
		trap "rm -r $$tmp" ERR EXIT &&\
		texi2any -o $$tmp --html --css-include=toolshed/gambit.css\
			gambit.txi &&\
		for f in $$tmp/*.html; do\
			sed -f toolshed/parenthesize-defs.sed "$$f"\
				> html-modules/"$${f##*/}";\
		done

gambit.html: ${html-deps}
	texi2any -o - --html --no-split --css-include=toolshed/gambit.css \
		gambit.txi | sed -f toolshed/parenthesize-defs.sed > $@

gambit.txi: gambit-pristine.txi procedures/a/pairs-lists.txi \
            procedures/a/strings.txi
	sed 's/^\(@include[[:blank:]]\{1,\}procedures\/\)/\1a\//'\
		gambit-pristine.txi > $@

procedures/a/pairs-lists.txi: procedures/pairs-lists.txi toolshed/annotate-txi.scm
	test -d procedures/a/ || mkdir -p procedures/a/; cd toolshed &&\
		${gsi} -f annotate-txi.scm ../procedures/pairs-lists.txi\
			> ../procedures/a/pairs-lists.txi

procedures/a/strings.txi: procedures/strings.txi toolshed/annotate-txi.scm
	test -d procedures/a/ || mkdir -p procedures/a/; cd toolshed &&\
		${gsi} -f annotate-txi.scm ../procedures/strings.txi\
			> ../procedures/a/strings.txi
