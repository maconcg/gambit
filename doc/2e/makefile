html-sources := gambit.txi toolshed/gambit.css
html-modules-dir := gambit-html
css-arg := --css-include=toolshed/gambit.css

# Colors are based on Protesilaos Stavrou's modus-operandi-tinted.
colors.fg-main      := \#000000
colors.fg-alt       := \#193668
colors.fg-dim       := \#595959
colors.bg-main      := \#fbf7f0
colors.bg-dim       := \#efe9dd
colors.link         := \#3548cf
colors.link-visited := \#721045
colors.border       := \#9f9690
colors.emphasis     := \#624416
colors.false        := \#63192a
colors.arg          := ${colors.link-visited}
colors.comment      := ${colors.fg-dim}
colors.hr           := ${colors.border}

default: html info txt

.PHONY: clean default html html-modules html-monolith info txt

clean:
	rm -fr ${html-modules-dir}/ gambit.html gambit.info gambit.txt

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

toolshed/gambit.css: toolshed/gambit.css.in
	sed -e 's/%fg-main%/${colors.fg-main}/'\
	    -e 's/%fg-alt%/${colors.fg-alt}/'\
	    -e 's/%fg-dim%/${colors.fg-dim}/'\
	    -e 's/%bg-main%/${colors.bg-main}/'\
	    -e 's/%bg-dim%/${colors.bg-dim}/'\
	    -e 's/%link%/${colors.link}/'\
	    -e 's/%link-visited%/${colors.link-visited}/'\
	    -e 's/%arg%/${colors.arg}/'\
	    -e 's/%border%/${colors.border}/'\
	    -e 's/%comment/${colors.comment}/'\
	    -e 's/%emphasis%/${colors.emphasis}/'\
	    -e 's/%false%/${colors.false}/'\
	    -e 's/%hr%/${colors.hr}/' toolshed/gambit.css.in > $@
