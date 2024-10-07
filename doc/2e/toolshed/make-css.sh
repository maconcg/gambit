readonly template="$1"

. toolshed/modus-operandi-colors.sh
. toolshed/modus-vivendi-colors.sh

substitute() {
    sed -n "/^\/\* BEGIN COLORS \*\/\$/,/^\/\* END COLORS \*\/\$/ {
                /^\/\*/! {
                    s/%bg-deftp-l%/$bg_deftp_l/
                    s/%bg-deftp-r%/$bg_deftp_r/
                    s/%bg-deftypefn-l%/$bg_deftypefn_l/
                    s/%bg-deftypefn-r%/$bg_deftypefn_r/
                    s/%bg-deftypevr-l%/$bg_deftypevr_l/
                    s/%bg-deftypevr-r%/$bg_deftypevr_r/
                    s/%bg-dim%/$bg_dim/
                    s/%bg-inactive%/$bg_inactive/
                    s/%bg-main%/$bg_main/
                    s/%fg-alt%/$fg_alt/
                    s/%fg-dim%/$fg_dim/
                    s/%fg-main%/$fg_main/
                    s/%border%/$border/
                    s/%category-def%/$category_def/
                    s/%char%/$char/
                    s/%comment/$comment/
                    s/%def-var%/$def_var/
                    s/%emphasis%/$emphasis/
                    s/%false%/$false/
                    s/%link%/$link/
                    s/%link-visited%/$link_visited/
                    s/%ok%/$ok/
                    s/%sexp-paren%/$sexp_paren/
                    s/%string%/$string/
                    s/%syntax%/$syntax/
                    p
                }
           }" "$template"
}

# Light mode (default)
bg_deftp_l="$mo_bg_ochre"6f
bg_deftp_r="$mo_bg_ochre"3f
bg_deftypefn_l="$mo_bg_blue_subtle"6f
bg_deftypefn_r="$mo_bg_blue_subtle"3f
bg_deftypevr_l="$mo_bg_clay"6f
bg_deftypevr_r="$mo_bg_clay"3f
bg_dim="$mo_bg_dim"
bg_inactive="$mo_bg_inactive"
bg_main="$mo_bg_main"
fg_alt="$mo_fg_alt"
fg_dim="$mo_fg_dim"
fg_main="$mo_fg_main"
border="$mo_border"
category_def="$mo_fg_alt"
char="$mo_red_faint"
comment="$mo_fg_dim"
def_var="$mo_magenta"
emphasis="$mo_yellow_faint"
false="$mo_fg_alt"
link="$mo_blue_warmer"
link_visited="$link"
ok="$mo_fg_alt"
sexp_paren="$mo_fg_dim"
string="$mo_green_cooler"
syntax="$mo_magenta_cooler"

substitute

# Dark mode
bg_deftp_l="$mv_bg_ochre"6f
bg_deftp_r="$mv_bg_ochre"3f
bg_deftypefn_l="$mv_bg_blue_subtle"6f
bg_deftypefn_r="$mv_bg_blue_subtle"3f
bg_deftypevr_l="$mv_bg_clay"6f
bg_deftypevr_r="$mv_bg_clay"3f
bg_dim="$mv_bg_dim"
bg_inactive="$mv_bg_inactive"
bg_main="$mv_bg_main"
fg_alt="$mv_fg_alt"
fg_dim="$mv_fg_dim"
fg_main="$mv_fg_main"
border="$mv_border"
category_def="$mv_fg_alt"
char="$mv_red_faint"
comment="$mv_fg_dim"
def_var="$mv_magenta"
emphasis="$mv_yellow_faint"
false="$mv_fg_alt"
link="$mv_blue_warmer"
link_visited="$link"
ok="$mv_fg_alt"
sexp_paren="$mv_fg_dim"
string="$mv_green_cooler"
syntax="$mv_magenta_cooler"

echo
echo '@media (prefers-color-scheme: dark) {'
substitute | sed 's/^/    /'
echo '}'

sed -n '/^\/\* END COLORS \*\/$/,$ {
            /^\/\* END COLORS \*\/$/!p
        }' "$template"
