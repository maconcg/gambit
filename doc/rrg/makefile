default:
	@echo no default

.PHONY: all clean default gauntlet highlight

gsc ?= gsc
gsi ?= gsi

SCM ?= examples/gauntlet.scm

clean:
	rm -f gambit*.html gambit.txi toolshed/*.css toolshed/*.html\
		toolshed/macros+vars.txi
	rm -fr procedures/c/

gambit-pristine.html: gambit-pristine.txi toolshed/macros+vars.txi
	texi2any -o $@ --html --no-split gambit.txi

gambit-pristine.txi: toolshed/macros+vars.txi

gambit-css.html: gambit-pristine.txi toolshed/gambit.css
	texi2any -o $@ --html --no-split --css-include=toolshed/gambit.css \
		gambit-pristine.txi

highlight: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	cd toolshed && ${gsi} -f scm-to-html.scm -e ${SCM}
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

gambit.html: gambit.txi procedures/c/pairs-lists.txi procedures/c/strings.txi\
             toolshed/gambit.css toolshed/parenthesize-defs.sed
	texi2any -o - --html --no-split --css-include=toolshed/gambit.css \
		gambit.txi | sed -f toolshed/parenthesize-defs.sed > $@

gambit.txi: gambit-pristine.txi
	sed 's/^\(@include[[:blank:]]\{1,\}procedures\/\)/\1c\//'\
		gambit-pristine.txi > $@

procedures/c/pairs-lists.txi: procedures/pairs-lists.txi toolshed/annotate-txi.scm
	test -d procedures/c/ || mkdir -p procedures/c/; cd toolshed &&\
		${gsi} -f annotate-txi.scm ../procedures/pairs-lists.txi\
			> ../procedures/c/pairs-lists.txi

procedures/c/strings.txi: procedures/strings.txi toolshed/annotate-txi.scm
	test -d procedures/c/ || mkdir -p procedures/c/; cd toolshed &&\
		${gsi} -f annotate-txi.scm ../procedures/strings.txi\
			> ../procedures/c/strings.txi
