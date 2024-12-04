default: echo no default

.PHONY: all default gauntlet highlight

gsc ?= gsc
gsi ?= gsi

SCM ?= examples/gauntlet.scm

highlight: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	cd toolshed && ${gsi} -f scm-to-html.scm -e ${SCM}
	mv toolshed/"$$(basename ${SCM})".html .

toolshed/gambit.css: toolshed/make-css.scm
	cd toolshed && ${gsi} -f make-css.scm -c

toolshed/gambit-examples.css: toolshed/make-css.scm
	cd toolshed && ${gsi} -f make-css.scm -e

toolshed/gambit-cm.css: toolshed/make-css.scm
	cd toolshed && ${gsi} -f make-css.scm -c

toolshed/gambit-examples-cm.css: toolshed/make-css.scm
	cd toolshed && ${gsi} -f make-css.scm -c -e

gauntlet: gauntlet.scm.html
gauntlet.scm.html: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	cd toolshed && ${gsi} -f scm-to-html.scm -e examples/gauntlet.scm
	mv toolshed/gauntlet.scm.html .
