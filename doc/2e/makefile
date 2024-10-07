default: info html txt

.PHONY: clean default html info txt html-modules-pristine               \
 html-modules-parens-only html-modules-color-only html-modules          \
 html-monolith-parens-only html-monolith-color-only html-monolith

clean:
	rm -fr gambit-html/ gambit-html-pristine/ gambit-html-parens-only/      \
		gambit-html-color-only/ gambit.html gambit-pristine.html        \
		gambit-parens-only.html gambit-color-only.html gambit.txt       \
		gambit.info gambit.incolor.txi procedures/*.incolor.txi         \
		toolshed/gambit.css toolshed/colorize-examples.sed

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
gambit.html: gambit-color-only.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gambit-color-only.html > $@

gambit-color-only.html: gambit.incolor.txi toolshed/gambit.css
	texi2any -o $@ --html --css-include=toolshed/gambit.css --no-split \
		gambit.incolor.txi

gambit.incolor.txi: gambit.txi procedures/pairs-lists.incolor.txi procedures/strings.incolor.txi
	sed '/^@include  *procedures\//s/\.txi$$/.incolor.txi/' gambit.txi > $@

toolshed/colorize-examples.sed: toolshed/colorize-examples.sed.sh
	sh -efu toolshed/colorize-examples.sed.sh > $@

procedures/strings.incolor.txi: procedures/strings.txi toolshed/colorize-examples.sed
	sed -f toolshed/colorize-examples.sed procedures/strings.txi > $@

procedures/pairs-lists.incolor.txi: procedures/pairs-lists.txi toolshed/colorize-examples.sed
	sed -f toolshed/colorize-examples.sed procedures/pairs-lists.txi > $@

toolshed/gambit.css: toolshed/gambit.css.in toolshed/make-css.sh
	sh -efu toolshed/make-css.sh toolshed/gambit.css.in > $@

gambit-pristine.html: gambit.txi toolshed/gambit.css
	texi2any -o $@ --html --css-include=toolshed/gambit.css --no-split \
		gambit.txi

gambit-parens-only.html: gambit-pristine.html toolshed/parenthesize-defs.sed
	sed -f toolshed/parenthesize-defs.sed gambit-pristine.html > $@

# html-modules-pristine: gambit-html-pristine/.stamp

# html-modules: gambit-html/.stamp
# gambit-html/.stamp: gambit.incolor.txi toolshed/parenthesize-defs.sed
# 	sed -f toolshed/parenthesize-defs.sed gambit-parens-only.html > $@

# gambit-html-pristine/.stamp: gambit.txi toolshed/gambit.css
# 	texi2any -o gambit-html-pristine \
# 		--html --css-include=toolshed/gambit.css gambit.txi
# 	touch $@

# html-modules-color-only: gambit-html-color-only/.stamp
# gambit-html-color-only/.stamp: gambit.incolor.txi toolshed/gambit.css
# 	texi2any -o gambit-html-color-only \
# 		--html --css-include=toolshed/gambit.css gambit.incolor.txi
# 	touch $@

# html-modules-parens-only: gambit-html-parens-only/.stamp
# gambit-html-parens-only/.stamp: gambit-html-pristine/.stamp \
#                                         toolshed/parenthesize-defs.sed
# 	mkdir -p gambit-html-parens-only
# 	for h in gambit-html-pristine/*.html; do\
# 		sed -f toolshed/parenthesize-defs.sed "$$h"\
# 			> gambit-html-parens-only/"$${h#*/}";\
# 	done
# 	touch $@

# html-modules: gambit-html/.stamp
# gambit-html/.stamp: gambit-html-color-only/.stamp \
#                     toolshed/parenthesize-defs.sed
#         mkdir -p gambit-html
# 	for h in gambit-html-color-only/*.html; do\
# 		sed -f toolshed/parenthesize-defs.sed "$$h"\
# 			> gambit-html/"$${h#*/}";\
# 	done
# 	touch $@
