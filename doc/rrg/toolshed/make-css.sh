# Copyright (c) 2024 by Macon Gambill, All Rights Reserved.
readonly template="$1"

. toolshed/data/modus-operandi-colors.sh
. toolshed/data/modus-vivendi-colors.sh

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
                    s/%code-comment%/$code_comment/
                    s/%def-var%/$def_var/
                    s/%emphasis%/$emphasis/
                    s/%exception%/$exception/
                    s/%false%/$false/
                    s/%link%/$link/
                    s/%link-visited%/$link_visited/
                    s/%ok%/$ok/
                    s/%problem%/$problem/
                    s/%sexp-paren%/$sexp_paren/
                    s/%sharp%/$sharp/
                    s/%string%/$string/
                    s/%syntax%/$syntax/
                    s/%todo%/$todo/
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
char="$mo_identifier"
code_comment="$mo_yellow_faint"
def_var="$mo_magenta"
emphasis="$mo_yellow_faint"
exception="$mo_red_warmer"
false="$mo_fg_alt"
link="$mo_blue_warmer"
link_visited="$link"
ok="$mo_slate"
problem="$mo_bg_yellow_intense"
sexp_paren="$mo_fg_dim"
sharp="$mo_red_faint"
string="$mo_green"
syntax="$mo_magenta_cooler"
todo="$mo_bg_red_intense"

substitute

# Dark mode
bg_deftp_l="$mv_bg_ochre"bf
bg_deftp_r="$mv_bg_ochre"9f
bg_deftypefn_l="$mv_bg_blue_subtle"6f
bg_deftypefn_r="$mv_bg_blue_subtle"3f
bg_deftypevr_l="$mv_bg_clay"af
bg_deftypevr_r="$mv_bg_clay"8f
bg_dim="$mv_bg_dim"
bg_inactive="$mv_bg_inactive"
bg_main="$mv_bg_main"
fg_alt="$mv_fg_alt"
fg_dim="$mv_fg_dim"
fg_main="$mv_fg_main"
border="$mv_border"
category_def="$mv_fg_alt"
char="$mv_identifier"
code_comment="$mv_yellow_faint"
def_var="$mv_magenta"
emphasis="$mv_yellow_faint"
exception="$mv_red_warmer"
false="$mv_fg_alt"
link="$mv_blue_warmer"
link_visited="$link"
ok="$mv_slate"
problem="$mv_bg_yellow_intense"
sexp_paren="$mv_fg_dim"
sharp="$mv_red_faint"
string="$mv_green"
syntax="$mv_magenta_cooler"
todo="$mv_bg_red_intense"

echo
echo '@media (prefers-color-scheme: dark) {'
substitute | sed 's/^/    /'
echo '}'

sed -n '/^\/\* END COLORS \*\/$/,$ {
            /^\/\* END COLORS \*\/$/!p
        }' "$template"