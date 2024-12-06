default:; @echo no default

.PHONY: all clean default gauntlet highlight

gsc ?= gsc
gsi ?= gsi

SCM ?= examples/gauntlet.scm

clean:
	rm -f toolshed/*.css toolshed/*.html toolshed/macros.txi

highlight: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	cd toolshed && ${gsi} -f scm-to-html.scm -e ${SCM}
	mv toolshed/"$$(basename ${SCM})".html .

toolshed/gambit.css: toolshed/write-css.scm
	cd toolshed && ${gsi} -f write-css.scm -c > gambit.css

toolshed/gambit-examples.css: toolshed/write-css.scm
	cd toolshed && ${gsi} -f write-css.scm -e > gambit-examples.css

toolshed/gambit-cm.css: toolshed/write-css.scm
	cd toolshed && ${gsi} -f write-css.scm -c > gambit-cm.css

toolshed/gambit-examples-cm.css: toolshed/write-css.scm
	cd toolshed && ${gsi} -f write-css.scm -c -e > gambit-examples-cm.css

toolshed/macros.txi: toolshed/write-macros.scm
	cd toolshed && ${gsi} -f write-macros.scm > macros.txi

gauntlet: gauntlet.scm.html
gauntlet.scm.html: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	cd toolshed && ${gsi} -f scm-to-html.scm -e examples/gauntlet.scm
	mv toolshed/gauntlet.scm.html .
