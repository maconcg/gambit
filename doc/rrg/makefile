default: gambit.html gambit.info gambit.txt

.PHONY: clean compile-adorn compile-exe default extraclean highlight \
 highlight-cm

GSC ?= gsc
GSI ?= gsi
SCM ?= toolshed/examples/gauntlet.scm

html-common-deps = gambit.txi procedures/a/pairs-lists.txi \
 procedures/a/strings.txi toolshed/parenthesize-html.sed

src-lib = ../../lib
lib-samples = _eval _io _kernel _module _nonstd _num _system _thread \
 syntax-case sys

r7rs-deps = toolshed/macros+vars.txi r7rs/bibliography.txi \
 r7rs/r7rs-pristine.txi r7rs/copying/copying.txi r7rs/copying/fdl-1.3.texi \
 r7rs/prose/summary.txi r7rs/prose/introduction.txi r7rs/prose/overview.txi \
 r7rs/prose/lexical-conventions.txi r7rs/prose/basic-concepts.txi \
 r7rs/prose/expressions.txi r7rs/prose/standard-procedures.txi

r7rs-annotated-prose = r7rs/prose/a/summary.txi r7rs/prose/a/introduction.txi \
 r7rs/prose/a/overview.txi r7rs/prose/a/lexical-conventions.txi \
 r7rs/prose/a/basic-concepts.txi r7rs/prose/a/expressions.txi \
 r7rs/prose/a/standard-procedures.txi

set-scm_to_html = \
if test -x scm-to-html; then\
    readonly scm_to_html=./scm-to-html;\
else\
    readonly scm_to_html='${GSI} -f scm-to-html.scm';\
fi

annotate-procedures-file = \
test -d procedures/a/ || mkdir -p procedures/a/;\
cd toolshed &&\
${GSI} -f annotate-txi.scm ../procedures/"$$txi"\
> ../procedures/a/"$$txi"

annotate-r7rs-procedures-file = \
test -d r7rs/procedures/a/ || mkdir -p r7rs/procedures/a/;\
cd toolshed &&\
${GSI} -f annotate-txi.scm ../r7rs/procedures/"$$txi"\
> ../r7rs/procedures/a/"$$txi"

annotate-r7rs-prose-file = \
test -d r7rs/prose/a/ || mkdir -p r7rs/prose/a/;\
cd toolshed &&\
${GSI} -f annotate-txi.scm ../r7rs/prose/"$$txi"\
> ../r7rs/prose/a/"$$txi"

adorn-lib = toolshed/adorn/adorn.sld toolshed/adorn/adornment.scm \
 toolshed/adorn/binding-mesg-handlers.scm \
 toolshed/adorn/char-mesg-handlers.scm \
 toolshed/adorn/comment-mesg-handlers.scm toolshed/adorn/helpers.scm \
 toolshed/adorn/matching.scm toolshed/adorn/numeric-mesg-handlers.scm \
 toolshed/adorn/other-mesg-handlers.scm toolshed/adorn/rt-syntax-handlers.scm \
 toolshed/adorn/symmetric-mesg-handlers.scm

clean:
	rm -f *.html *.tgz {gambit,r7rs}.{info,txi,txt} toolshed/*.css \
		toolshed/*.html toolshed/macros+vars.txi r7rs/r7rs.txi \
		r7rs/r7rs-pristine.{info,txt}
	rm -f -r procedures/a/ html-modules/ html-modules-cm/ \
		r7rs/procedures/a/ r7rs/prose/a/ r7rs-modules/

extraclean: clean
	rm -f toolshed/adorn/adorn.o1 toolshed/scm-to-html

compile-adorn: toolshed/adorn/adorn.o1

compile-exe: toolshed/scm-to-html

toolshed/scm-to-html: toolshed/scm-to-html.scm toolshed/adorn/adorn.o1
	if test -e toolshed/scm-to-html.c; then\
		rm toolshed/scm-to-html.c;\
	fi &&\
	${GSC} -exe toolshed/scm-to-html.scm

toolshed/adorn/adorn.o1: ${adorn-lib}
	if test -e toolshed/adorn/adorn.c; then\
		rm toolshed/adorn/adorn.c;\
	fi &&\
	${GSC} -o $@ toolshed/adorn/adorn

${r7rs-annotated-prose}: ${adorn-lib} toolshed/annotate-txi.scm

toolshed/annotate-txi.scm: toolshed/adorn/adorn.o1

gambit-samples.tgz: gambit-pristine.html gambit-css.html toolshed/scm-to-html \
                    .WAIT gambit.html gambit.cm.html gambit.info gambit.txt \
                    gauntlet.scm.html gauntlet.scm.cm.html html-modules \
                    html-modules-cm
	readonly td=$$(mktemp -d) && {\
		trap "rm -r $$td" ERR EXIT &&\
		mkdir -p $$td/gambit-samples/{adorn,lib} &&\
		cp gambit.{cm.html,html,info,txt} gambit-{pristine,css}.html \
			gauntlet.scm{,.cm}.html $$td/gambit-samples &&\
		cp -R html-modules html-modules-cm $$td/gambit-samples &&\
		cd toolshed &&\
		${set-scm_to_html} &&\
		for scm in ${lib-samples}; do\
			$${scm_to_html} ../${src-lib}/$${scm}.scm &&\
			$${scm_to_html} -c ../${src-lib}/$${scm}.scm &&\
			mv $${scm}.scm{,.cm}.html $$td/gambit-samples/lib;\
		done &&\
		for scm in adorn/*.scm adorn/*.sld; do\
			$${scm_to_html} $$(realpath "$${scm}") &&\
			$${scm_to_html} -c $$(realpath "$${scm}") &&\
			mv "$${scm##*/}"{,.cm}.html $$td/gambit-samples/adorn;\
		done &&\
		cd $$td &&\
		if test -n "$$(command -v pax)"; then\
			readonly archive='pax -w';\
		else\
			readonly archive='tar -c';\
		fi;\
		$$archive -z -f "$$OLDPWD"/../$@ gambit-samples;\
	}

gambit.info: gambit.txi
	texi2any -o $@ --info --no-split gambit.txi

gambit.txt: gambit.txi
	texi2any -o $@ --plaintext gambit.txi

gambit-pristine.html: gambit-pristine.txi toolshed/macros+vars.txi
	texi2any -o $@ --html --no-split gambit-pristine.txi

gambit-pristine.txi: toolshed/macros+vars.txi

gambit-css.html: gambit-pristine.txi toolshed/gambit.css
	texi2any -o $@ --html --no-split --css-include=toolshed/gambit.css \
		gambit-pristine.txi

highlight: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	readonly scm=$$(realpath "${SCM}") &&\
	cd toolshed &&\
	${set-scm_to_html} &&\
	$${scm_to_html} "$$scm" &&\
	mv "$${scm##*/}".html ../"$$(basename ${SCM})".html

highlight-cm: toolshed/gambit-examples.cm.css toolshed/scm-to-html.scm
	readonly scm=$$(realpath "${SCM}") &&\
	cd toolshed &&\
	${set-scm_to_html} &&\
	$${scm_to_html} -c "$$scm" &&\
	mv "$${scm##*/}".cm.html ../"$$(basename ${SCM})".cm.html

toolshed/gambit.css: toolshed/write-css.scm
	cd toolshed && ${GSI} -f write-css.scm > gambit.css

toolshed/gambit.cm.css: toolshed/write-css.scm
	cd toolshed && ${GSI} -f write-css.scm -c > gambit.cm.css

toolshed/gambit-examples.css: toolshed/write-css.scm
	cd toolshed && ${GSI} -f write-css.scm -e > gambit-examples.css

toolshed/gambit-examples.cm.css: toolshed/write-css.scm
	cd toolshed && ${GSI} -f write-css.scm -c -e > gambit-examples.cm.css

toolshed/macros+vars.txi: toolshed/write-macros+vars.scm
	cd toolshed && ${GSI} -f write-macros+vars.scm > macros+vars.txi

gauntlet.scm.html: toolshed/gambit-examples.css toolshed/scm-to-html.scm
	cd toolshed &&\
	${set-scm_to_html} &&\
	$${scm_to_html} examples/gauntlet.scm &&\
	mv gauntlet.scm.html ../gauntlet.scm.html

gauntlet.scm.cm.html: toolshed/gambit-examples.cm.css toolshed/scm-to-html.scm
	cd toolshed &&\
	${set-scm_to_html} &&\
	$${scm_to_html} -c examples/gauntlet.scm &&\
	mv gauntlet.scm.cm.html ../gauntlet.scm.cm.html

html-modules: ${html-common-deps} toolshed/gambit.css
	test -d html-modules || mkdir -p html-modules
	readonly tmp=$$(mktemp -d) && {\
		trap "rm -r $$tmp" ERR EXIT &&\
		texi2any -o $$tmp --html --css-include=toolshed/gambit.css\
			gambit.txi &&\
		for f in $$tmp/*.html; do\
			sed -f toolshed/parenthesize-html.sed "$$f"\
				> html-modules/"$${f##*/}";\
		done;\
	}

html-modules-cm: ${html-common-deps} toolshed/gambit.cm.css
	test -d html-modules-cm || mkdir -p html-modules-cm
	readonly tmp=$$(mktemp -d) && {\
		trap "rm -r $$tmp" ERR EXIT &&\
		texi2any -o $$tmp --html --css-include=toolshed/gambit.cm.css\
			gambit.txi &&\
		for f in $$tmp/*.html; do\
			sed -f toolshed/parenthesize-html.sed "$$f"\
				> html-modules-cm/"$${f##*/}";\
		done;\
	}

gambit.html: ${html-common-deps} toolshed/gambit.css
	texi2any -o - --html --no-split --css-include=toolshed/gambit.css\
		gambit.txi | sed -f toolshed/parenthesize-html.sed > $@

gambit.cm.html: ${html-common-deps} toolshed/gambit.cm.css
	texi2any -o - --html --no-split --css-include=toolshed/gambit.cm.css\
		gambit.txi | sed -f toolshed/parenthesize-html.sed > $@

gambit.txi: gambit-pristine.txi procedures/a/pairs-lists.txi \
            procedures/a/strings.txi
	sed 's/^\(@include[[:blank:]]\{1,\}procedures\/\)/\1a\//'\
		gambit-pristine.txi > $@

procedures/a/pairs-lists.txi: procedures/pairs-lists.txi \
                              toolshed/annotate-txi.scm
	readonly txi=pairs-lists.txi && ${annotate-procedures-file}

procedures/a/strings.txi: procedures/strings.txi toolshed/annotate-txi.scm
	readonly txi=strings.txi && ${annotate-procedures-file}

r7rs-samples.tgz: r7rs-pristine.html r7rs-plain.html r7rs-plain-parens.html \
                  r7rs.html r7rs.info r7rs/r7rs-pristine.info r7rs.txt \
                  r7rs/r7rs-pristine.txt
	readonly td=$$(mktemp -d) && {\
		trap "rm -r $$td" ERR EXIT &&\
		mkdir $$td/r7rs-samples &&\
		cp r7rs{,-pristine,-plain,-plain-parens}.html\
			r7rs/r7rs-pristine.{info,txt} r7rs.{info,txt}\
			$$td/r7rs-samples &&\
		cd toolshed &&\
		${set-scm_to_html} &&\
		cd $$td &&\
		if test -n "$$(command -v pax)"; then\
			readonly archive='pax -w';\
		else\
			readonly archive='tar -c';\
		fi;\
		$$archive -z -f "$$OLDPWD"/../$@ r7rs-samples;\
	}

r7rs/procedures/a/equivalence-predicates.txi: \
 r7rs/procedures/equivalence-predicates.txi
	readonly txi=equivalence-predicates.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/prose/a/summary.txi: r7rs/prose/summary.txi
	readonly txi=summary.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/introduction.txi: r7rs/prose/introduction.txi
	readonly txi=introduction.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/overview.txi: r7rs/prose/overview.txi
	readonly txi=overview.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/lexical-conventions.txi: r7rs/prose/lexical-conventions.txi
	readonly txi=lexical-conventions.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/basic-concepts.txi: r7rs/prose/basic-concepts.txi
	readonly txi=basic-concepts.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/expressions.txi: r7rs/prose/expressions.txi
	readonly txi=expressions.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/standard-procedures.txi: r7rs/prose/standard-procedures.txi
	readonly txi=standard-procedures.txi && ${annotate-r7rs-prose-file}

r7rs/r7rs.txi: ${r7rs-deps} ${adorn-lib} ${r7rs-annotated-prose} \
 r7rs/r7rs-pristine.txi r7rs/procedures/a/equivalence-predicates.txi
	sed -e 's/^\(@include[[:blank:]]\{1,\}procedures\/\)/\1a\//'\
		-e 's/^\(@include[[:blank:]]\{1,\}prose\/\)/\1a\//'\
		r7rs/r7rs-pristine.txi > $@

r7rs-plain.html: r7rs-pristine.html toolshed/asciify-html-brackets.sed
	sed -f toolshed/asciify-html-brackets.sed r7rs-pristine.html > $@

r7rs-plain-parens.html: r7rs-plain.html toolshed/parenthesize-html.sed
	sed -f toolshed/parenthesize-html.sed r7rs-plain.html > $@

r7rs-pristine.html: ${r7rs-deps}
	cd r7rs &&\
	texi2any -o - --html --no-split r7rs-pristine.txi > ../$@

r7rs-modules: r7rs/r7rs.txi toolshed/gambit.css toolshed/parenthesize-html.sed
	test -d r7rs/r7rs-modules || mkdir -p r7rs/r7rs-modules
	cd r7rs &&\
	readonly tmp=$$(mktemp -d) && {\
		trap "rm -r $$tmp" ERR EXIT &&\
		texi2any -o $$tmp --html --css-include=../toolshed/gambit.css\
			r7rs.txi &&\
		for f in $$tmp/*.html; do\
			sed -f ../toolshed/parenthesize-html.sed "$$f"\
				> r7rs-modules/"$${f##*/}";\
		done &&\
		if test -d ../r7rs-modules; then rm -r ../r7rs-modules; fi &&\
		mv r7rs-modules "$$OLDPWD";\
	}

r7rs.html: r7rs/r7rs.txi toolshed/gambit.css toolshed/parenthesize-html.sed
	cd r7rs &&\
	texi2any -o - --html --no-split --css-include=../toolshed/gambit.css \
		r7rs.txi | sed -f ../toolshed/parenthesize-html.sed > ../$@

r7rs/r7rs-pristine.info: ${r7rs-deps}
	cd r7rs &&\
	texi2any -o - --info --no-split r7rs-pristine.txi > ../$@;

r7rs.info: r7rs/r7rs-pristine.info toolshed/parenthesize-info.sed
	sed -E -f toolshed/parenthesize-info.sed r7rs/r7rs-pristine.info > $@;

r7rs/r7rs-pristine.txt: ${r7rs-deps}
	cd r7rs &&\
	texi2any -o - --plaintext --no-split r7rs-pristine.txi > ../$@;

r7rs.txt: r7rs/r7rs-pristine.txt toolshed/parenthesize-info.sed
	sed -E -f toolshed/parenthesize-info.sed r7rs/r7rs-pristine.txt > $@;
