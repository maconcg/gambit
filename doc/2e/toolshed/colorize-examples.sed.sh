readonly syntax='
and
begin
case
case-lambda
cond
cond-expand
define
define-library
define-record-type
define-syntax
define-values
delay
delay-force
do
error
guard
if
import
include
include-ci
lambda
let
let*
let*-values
let-syntax
let-values
letrec
letrec*
letrec-syntax
load
or
parameterize
quasiquote
quote
set!
syntax-error
syntax-rules
unless
when'

printf '%s\n' '/^@lisp$/,/^@end lisp$/ {'

# We only want to colorize the text to the left of @ok/@exception.
# Store all text to the right of "@ok{" in the hold space, then use a
# substitution to remove that text from the pattern space.
for macro in ok exception; do
    printf '    %s\n' "/@$macro{/ {
        h
        x
        s/^.*@$macro{//
        x
    }"
done

# Wrap each character in @char{}.
printf '%s\n\n' '    /#\\/ {
        s/#\\\([[:graph:]]\)$/@char{\1}/g
        s/#\\\([[:graph:]]\)\([])[:blank:]]\)/@char{\1}\2/g
        s/#\\\([[:lower:]]\{2,\}\)$/@char{\1}/g
        s/#\\\([[:lower:]]\{2,\}\)\([])[:blank:]]\)/@char{\1}\2/g
        s/#\\\(x[[:xdigit:]]\{1,\}\)$/@char{\1}/g
        s/#\\\(x[[:xdigit:]]\{1,\}\)\([])[:blank:]]\)/@char{\1}\2/g
    }'

# Wrap each special syntactic form in @syntax{}.
for form in $syntax; do
    case "$form" in
        *\**) s="${form%%\**}\\*${form##*\*}" ;;
        *)    s="$form" ;;
    esac

    printf '    %s\n    %s\n' \
           "s/\(([[:blank:]]*\)$s\$/\1@syntax{$s}/g" \
           "s/\(([[:blank:]]*\)$s\([])[:blank:]]\)/\1@syntax{$s}\2/g"
done

# Wrap each "string" in @string{}.
printf '    %s\n\n' 's/"\([^"]*\)"/@string{\1}/g'

# Add back the part we've been keeping in the hold space.
printf '    %s\n' '/@ok{/ {
        s/@ok{.*$/@ok{/
        G
        s/\n//
    }'

# Wrap comments last so they may occur to the right of @ok/@exception.
printf '    %s\n' 's/\([[:blank:]]\);\(.*\)$/\1@codecomment{;\2}/
}'
