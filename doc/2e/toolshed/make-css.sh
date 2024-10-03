#!/bin/sh -fure
# Colors are based on Protesilaos Stavrou's modus-themes.

readonly template=${1:?}

function substitute {
    sed -n "/^\/\* BEGIN COLORS \*\/\$/,/^\/\* END COLORS \*\/\$/ {
                /^\/\*/! {
                    s/%fg-main%/$fg_main/
                    s/%fg-alt%/$fg_alt/
                    s/%fg-dim%/$fg_dim/
                    s/%bg-main%/$bg_main/
                    s/%bg-dim%/$bg_dim/
                    s/%link%/$link/
                    s/%link-visited%/$link_visited/
                    s/%arg%/$arg/
                    s/%border%/$border/
                    s/%comment/$comment/
                    s/%emphasis%/$emphasis/
                    s/%false%/$false/
                    s/%hr%/$hr/
                    p
                }
           }" "$template"
}

# Default, based on modus-operandi-tinted
fg_main='#000000'
fg_alt='#193668'
fg_dim='#595959'
bg_main='#fbf7f0'
bg_dim='#efe9dd'
link='#3548cf'
link_visited='#721045'
border='#9f9690'
emphasis='#624416'
false='#63192a'
arg="$link_visited"
comment="$fg_dim"
hr="$border"

substitute

# Dark, based on modus-vivendi-tinted
fg_main='#ffffff'
fg_alt='#c6daff'
fg_dim='#989898'
bg_main='#0d0e1c'
bg_dim='#1d2235'
link='#79a8ff'
link_visited='#feacd0'
border='#61647a'
emphasis='#d2b580'
false='#f1b090'
arg="$link_visited"
comment="$fg_dim"
hr="$border"

echo
echo '@media (prefers-color-scheme: dark) {'
substitute | sed 's/^/    /'
echo '}'

sed -n '/^\/\* END COLORS \*\/$/,$ {
            /^\/\* END COLORS \*\/$/!p
        }' "$template"
