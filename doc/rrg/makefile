default: gambit.html gambit.info gambit.txt

.PHONY: clean compile-adorn compile-exe default extraclean highlight \
 highlight-cm

GSC ?= gsc
GSI ?= gsi
SCM ?= toolshed/examples/gauntlet.scm

html-common-deps = gambit.txi procedures/a/pairs-lists.txi \
 procedures/a/strings.txi toolshed/parenthesize-html.sed \
 toolshed/ellipsize-cxr-html.sed toolshed/annotate-syntax-html.sed

src-lib = ../../lib
lib-samples = _eval _io _kernel _module _nonstd _num _system _thread \
 syntax-case sys

r7rs-deps = toolshed/macros+vars.txi r7rs/bibliography.txi \
 r7rs/r7rs-pristine.txi r7rs/copying/copying.txi r7rs/copying/fdl-1.3.texi \
 r7rs/prose/0_summary.txi \
 r7rs/prose/0_introduction.txi \
 r7rs/prose/1_overview.txi \
 r7rs/prose/2_lexical-conventions.txi \
 r7rs/prose/3_basic-concepts.txi \
 r7rs/prose/4_expressions.txi \
 r7rs/prose/5_program-structure.txi \
 r7rs/prose/6_standard-procedures.txi \
 r7rs/procedures/6.1_equivalence-predicates.txi \
 r7rs/procedures/6.2_numbers.txi \
 r7rs/procedures/6.3_booleans.txi \
 r7rs/procedures/6.4_pairs-and-lists.txi \
 r7rs/procedures/6.5_symbols.txi \
 r7rs/procedures/6.6_characters.txi \
 r7rs/procedures/6.7_strings.txi \
 r7rs/procedures/6.8_vectors.txi \
 r7rs/procedures/6.9_bytevectors.txi \
 r7rs/procedures/6.10_control-features.txi \
 r7rs/procedures/6.11_exceptions.txi \
 r7rs/procedures/6.12_environments-and-evaluation.txi \
 r7rs/procedures/6.13_input-and-output.txi \
 r7rs/procedures/6.14_system-interface.txi \
 r7rs/prose/7.1_formal-syntax.txi \
 r7rs/prose/7.2_formal-semantics.txi \
 r7rs/prose/A_standard-libraries.txi \
 r7rs/prose/B_feature-identifiers.txi \
 r7rs/prose/_language-changes.txi \
 r7rs/prose/_additional-material.txi \
 r7rs/prose/_example.txi \

r7rs-annotated = \
 r7rs/prose/a/0_summary.txi \
 r7rs/prose/a/0_introduction.txi \
 r7rs/prose/a/1_overview.txi \
 r7rs/prose/a/2_lexical-conventions.txi \
 r7rs/prose/a/3_basic-concepts.txi \
 r7rs/prose/a/4_expressions.txi \
 r7rs/prose/a/5_program-structure.txi \
 r7rs/prose/a/6_standard-procedures.txi \
 r7rs/procedures/a/6.1_equivalence-predicates.txi \
 r7rs/procedures/a/6.2_numbers.txi \
 r7rs/procedures/a/6.3_booleans.txi \
 r7rs/procedures/a/6.4_pairs-and-lists.txi \
 r7rs/procedures/a/6.5_symbols.txi \
 r7rs/procedures/a/6.6_characters.txi \
 r7rs/procedures/a/6.7_strings.txi \
 r7rs/procedures/a/6.8_vectors.txi \
 r7rs/procedures/a/6.9_bytevectors.txi \
 r7rs/procedures/a/6.10_control-features.txi \
 r7rs/procedures/a/6.11_exceptions.txi \
 r7rs/procedures/a/6.12_environments-and-evaluation.txi \
 r7rs/procedures/a/6.13_input-and-output.txi \
 r7rs/procedures/a/6.14_system-interface.txi \
 r7rs/prose/a/7.1_formal-syntax.txi \
 r7rs/prose/a/7.2_formal-semantics.txi \
 r7rs/prose/a/A_standard-libraries.txi \
 r7rs/prose/a/B_feature-identifiers.txi \
 r7rs/prose/a/_language-changes.txi \
 r7rs/prose/a/_additional-material.txi \
 r7rs/prose/a/_example.txi

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

${r7rs-annotated}: ${adorn-lib} toolshed/annotate-txi.scm

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

gauntlet.scm.html: toolshed/gambit-examples.css toolshed/scm-to-html.scm \
 toolshed/adorn/adorn.o1
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
			sed -f toolshed/parenthesize-html.sed "$$f" |\
				sed -f toolshed/annotate-syntax-html.sed\
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
			sed -f toolshed/parenthesize-html.sed "$$f" |\
				sed -f toolshed/annotate-syntax-html.sed\
				> html-modules-cm/"$${f##*/}";\
		done;\
	}

gambit.html: ${html-common-deps} toolshed/gambit.css
	texi2any -o - --html --no-split --css-include=toolshed/gambit.css\
		gambit.txi | sed -f toolshed/parenthesize-html.sed |\
			sed -f toolshed/annotate-syntax-html.sed\
			-f toolshed/ellipsize-cxr-html.sed > $@

gambit.cm.html: ${html-common-deps} toolshed/gambit.cm.css
	texi2any -o - --html --no-split --css-include=toolshed/gambit.cm.css\
		gambit.txi | sed -f toolshed/parenthesize-html.sed |\
			sed -f toolshed/annotate-syntax-html.sed\
			-f toolshed/ellipsize-cxr-html.sed > $@

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

r7rs/procedures/a/6.1_equivalence-predicates.txi: \
 r7rs/procedures/6.1_equivalence-predicates.txi
	readonly txi=6.1_equivalence-predicates.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.2_numbers.txi: \
 r7rs/procedures/6.2_numbers.txi
	readonly txi=6.2_numbers.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.3_booleans.txi: \
 r7rs/procedures/6.3_booleans.txi
	readonly txi=6.3_booleans.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.4_pairs-and-lists.txi: \
 r7rs/procedures/6.4_pairs-and-lists.txi
	readonly txi=6.4_pairs-and-lists.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.5_symbols.txi: \
 r7rs/procedures/6.5_symbols.txi
	readonly txi=6.5_symbols.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.6_characters.txi: \
 r7rs/procedures/6.6_characters.txi
	readonly txi=6.6_characters.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.7_strings.txi: \
 r7rs/procedures/6.7_strings.txi
	readonly txi=6.7_strings.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.8_vectors.txi: \
 r7rs/procedures/6.8_vectors.txi
	readonly txi=6.8_vectors.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.9_bytevectors.txi: \
 r7rs/procedures/6.9_bytevectors.txi
	readonly txi=6.9_bytevectors.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.10_control-features.txi: \
 r7rs/procedures/6.10_control-features.txi
	readonly txi=6.10_control-features.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.11_exceptions.txi: \
 r7rs/procedures/6.11_exceptions.txi
	readonly txi=6.11_exceptions.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.12_environments-and-evaluation.txi: \
 r7rs/procedures/6.12_environments-and-evaluation.txi
	readonly txi=6.12_environments-and-evaluation.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.13_input-and-output.txi: \
 r7rs/procedures/6.13_input-and-output.txi
	readonly txi=6.13_input-and-output.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/procedures/a/6.14_system-interface.txi: \
 r7rs/procedures/6.14_system-interface.txi
	readonly txi=6.14_system-interface.txi &&\
	${annotate-r7rs-procedures-file}

r7rs/prose/a/0_summary.txi: r7rs/prose/0_summary.txi
	readonly txi=0_summary.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/0_introduction.txi: r7rs/prose/0_introduction.txi
	readonly txi=0_introduction.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/1_overview.txi: r7rs/prose/1_overview.txi
	readonly txi=1_overview.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/2_lexical-conventions.txi: r7rs/prose/2_lexical-conventions.txi
	readonly txi=2_lexical-conventions.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/3_basic-concepts.txi: r7rs/prose/3_basic-concepts.txi
	readonly txi=3_basic-concepts.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/4_expressions.txi: r7rs/prose/4_expressions.txi
	readonly txi=4_expressions.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/5_program-structure.txi: r7rs/prose/5_program-structure.txi
	readonly txi=5_program-structure.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/6_standard-procedures.txi: r7rs/prose/6_standard-procedures.txi
	readonly txi=6_standard-procedures.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/7.1_formal-syntax.txi: r7rs/prose/7.1_formal-syntax.txi
	readonly txi=7.1_formal-syntax.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/7.2_formal-semantics.txi: r7rs/prose/7.2_formal-semantics.txi
	readonly txi=7.2_formal-semantics.txi && ${annotate-r7rs-prose-file}

r7rs/prose/a/A_standard-libraries.txi: r7rs/prose/A_standard-libraries.txi \
 toolshed/linkify-appendix-A.scm
	readonly txi=A_standard-libraries.txi && readonly tmp=$$(mktemp) &&\
		trap "rm $$tmp" ERR EXIT &&\
		test -d r7rs/prose/a/ || mkdir -p r7rs/prose/a/;\
		cd toolshed &&\
		${GSI} -f annotate-txi.scm ../r7rs/prose/"$$txi" > $$tmp &&\
		${GSI} -f linkify-appendix-A.scm $$tmp\
			> ../r7rs/prose/a/"$$txi"

r7rs/prose/a/B_feature-identifiers.txi: r7rs/prose/B_feature-identifiers.txi
	readonly txi=B_feature-identifiers.txi &&\
		${annotate-r7rs-prose-file}

r7rs/prose/a/_language-changes.txi: r7rs/prose/_language-changes.txi
	readonly txi=_language-changes.txi &&\
		${annotate-r7rs-prose-file}

r7rs/prose/a/_additional-material.txi: r7rs/prose/_additional-material.txi
	readonly txi=_additional-material.txi &&\
		${annotate-r7rs-prose-file}

r7rs/prose/a/_example.txi: r7rs/prose/_example.txi
	readonly txi=_example.txi &&\
		${annotate-r7rs-prose-file}

r7rs/r7rs.txi: ${r7rs-deps} ${adorn-lib} ${r7rs-annotated} \
 r7rs/r7rs-pristine.txi
	sed -e 's/^\(@include[[:blank:]]\{1,\}procedures\/\)/\1a\//'\
		-e 's/^\(@include[[:blank:]]\{1,\}prose\/\)/\1a\//'\
		r7rs/r7rs-pristine.txi > $@

r7rs-plain.html: r7rs-pristine.html toolshed/asciify-html-brackets.sed
	sed -f toolshed/asciify-html-brackets.sed r7rs-pristine.html > $@

r7rs-plain-parens.html: r7rs-plain.html toolshed/parenthesize-html.sed \
 toolshed/ellipsize-cxr-html.sed
	sed -f toolshed/parenthesize-html.sed\
		-f toolshed/ellipsize-cxr-html.sed r7rs-plain.html > $@

r7rs-pristine.html: ${r7rs-deps}
	cd r7rs &&\
	texi2any -o - --html --no-split r7rs-pristine.txi > ../$@

r7rs-modules: r7rs/r7rs.txi toolshed/gambit.css \
 toolshed/parenthesize-html.sed toolshed/ellipsize-cxr-html.sed
	test -d r7rs/r7rs-modules || mkdir -p r7rs/r7rs-modules
	cd r7rs &&\
	readonly tmp=$$(mktemp -d) && {\
		trap "rm -r $$tmp" ERR EXIT &&\
		texi2any -o $$tmp --html --css-include=../toolshed/gambit.css\
			r7rs.txi &&\
		for f in $$tmp/*.html; do\
			sed -f ../toolshed/parenthesize-html.sed "$$f"\
				-f ../toolshed/ellipsize-cxr-html.sed\
					> r7rs-modules/"$${f##*/}";\
		done &&\
		if test -d ../r7rs-modules; then rm -r ../r7rs-modules; fi &&\
		mv r7rs-modules "$$OLDPWD";\
	}

r7rs.html: r7rs/r7rs.txi toolshed/gambit.css toolshed/parenthesize-html.sed \
 toolshed/ellipsize-cxr-html.sed toolshed/annotate-syntax-html.sed
	cd r7rs &&\
	texi2any -o - --html --no-split --css-include=../toolshed/gambit.css \
		r7rs.txi | sed -f ../toolshed/parenthesize-html.sed \
			-f ../toolshed/ellipsize-cxr-html.sed |\
			sed -f ../toolshed/annotate-syntax-html.sed > ../$@

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
