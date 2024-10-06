readonly template="${1:?}"

# Light color scheme based on Protesilaos Stavrou's modus-operandi
readonly l_bg_main='#ffffff' \
         l_bg_dim='#f8f9fa' \
         l_bg_inactive='#9f9f9f' \
         l_bg_clay='#f1c8b5' \
         l_bg_ochre='#f0e3c0' \
         l_fg_main='#000000' \
         l_fg_dim='#595959' \
         l_fg_alt='#193668' \
         l_border='#9f9f9f' \
         l_red_faint='#7f0000' \
         l_yellow_faint='#624416' \
         l_blue_warmer='#3548cf' \
         l_magenta='#721045' \
         l_bg_red_subtle='#ffcfbf' \
         l_bg_green_subtle='#b3fabf' \
         l_bg_blue_subtle='#ccdfff' \
         l_bg_yellow_subtle='#fff576' \
         l_bg_red_nuanced='#ffe8e8' \
         l_bg_blue_nuanced='#ecedff' \
         l_bg_yellow_nuanced='#f8f0d0'

# Dark color scheme based on Protesilaos Stavrou's modus-vivendi
readonly d_bg_main='#000000' \
         d_bg_dim='#1e1e1e' \
         d_bg_inactive='#303030' \
         d_bg_clay='#49191a' \
         d_bg_ochre='#462f20' \
         d_fg_main='#ffffff' \
         d_fg_dim='#989898' \
         d_fg_alt='#c6daff' \
         d_border='#646464' \
         d_red_faint='#ff9580' \
         d_yellow_faint='#d2b580' \
         d_blue_warmer='#79a8ff' \
         d_magenta='#feacd0' \
         d_bg_red_subtle='#620f2a' \
         d_bg_green_subtle='#00422a' \
         d_bg_blue_subtle='#242679' \
         d_bg_yellow_subtle='#4a4000' \
         d_bg_red_nuanced='#3a0c14' \
         d_bg_blue_nuanced='#12154a' \
         d_bg_yellow_nuanced='#381d0f'

substitute() {
    sed -n "/^\/\* BEGIN COLORS \*\/\$/,/^\/\* END COLORS \*\/\$/ {
                /^\/\*/! {
                    s/%bg-main%/${bg_main:?}/
                    s/%bg-dim%/${bg_dim:?}/g
                    s/%bg-inactive%/${bg_inactive:?}/
                    s/%fg-main%/${fg_main:?}/
                    s/%fg-alt%/${fg_alt:?}/
                    s/%fg-dim%/${fg_dim:?}/
                    s/%link%/${link:?}/
                    s/%link-visited%/${link_visited:?}/
                    s/%def-var%/${def_var:?}/
                    s/%comment/${comment:?}/
                    s/%emphasis%/${emphasis:?}/
                    s/%false%/${false:?}/
                    s/%border%/${border:?}/g
                    s/%category-def%/${category_def:?}/
                    s/%sexp-paren%/${sexp_paren:?}/
                    s/%ok%/${ok:?}/
                    s/%bg-deftp%/${bg_deftp:?}/g
                    s/%bg-deftypefn%/${bg_deftypefn:?}/g
                    s/%bg-deftypevr%/${bg_deftypevr:?}/g
                    p
                }
           }" "$template"
}

# Default, based on modus-operandi
bg_main="$l_bg_main"
bg_dim="$l_bg_dim"
bg_inactive="$l_bg_inactive"
fg_main="$l_fg_main"
fg_dim="$l_fg_dim"
fg_alt="$l_fg_alt"
emphasis="$l_yellow_faint"
link="$l_blue_warmer"
link_visited="$link"
false="$l_fg_alt"
def_var="$l_magenta"
comment="$l_fg_dim"
border="$l_border"
category_def="$l_fg_alt"
sexp_paren="$l_fg_dim"
ok="$l_fg_alt"
bg_deftp="$l_bg_ochre"
bg_deftypefn="$l_bg_blue_subtle"
bg_deftypevr="$l_bg_clay"

substitute

# Dark mode
bg_main="$d_bg_main"
bg_dim="$d_bg_dim"
bg_inactive="$d_bg_inactive"
fg_main="$d_fg_main"
fg_dim="$d_fg_dim"
fg_alt="$d_fg_alt"
emphasis="$d_yellow_faint"
link="$d_blue_warmer"
link_visited="$link"
false="$d_fg_alt"
def_var="$d_magenta"
comment="$d_fg_dim"
border="$d_border"
category_def="$d_fg_alt"
sexp_paren="$d_fg_dim"
ok="$d_fg_alt"
bg_deftp="$d_bg_ochre"
bg_deftypefn="$d_bg_blue_subtle"
bg_deftypevr="$d_bg_clay"

echo
echo '@media (prefers-color-scheme: dark) {'
substitute | sed 's/^/    /'
echo '}'

sed -n '/^\/\* END COLORS \*\/$/,$ {
            /^\/\* END COLORS \*\/$/!p
        }' "$template"
