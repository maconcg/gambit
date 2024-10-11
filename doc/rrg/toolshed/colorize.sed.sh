# Copyright (c) 2024 by Macon Gambill, All Rights Reserved.
readonly chars="$(sort -r toolshed/data/char-names)" # longest first
readonly char_refs="$(<toolshed/data/html-character-references)"
readonly sharps="$(<toolshed/data/sharp-objects)"
readonly syntax="$(<toolshed/data/syntax-words)"
readonly homogeneous_vectors="$(<toolshed/data/homogeneous-vectors)"
readonly identifier_chars='[-[:alnum:]!$%&*+./:<=>?@^_~]'
lpunct=\[\'',\\`)([:blank:][]'
rpunct=\['])[:blank:]]'

fstr() {
    printf 's/\\(%%s\\)%s\\(%%s\\)%s\\(%%s\\)/%%s%s%%s%s%s%%s/%%s\\n' \
           "${1?prefix}" "${2?suffix}" "${3?new prefix}" \
           "${4?new suffix}"
}

gensub() {
    printf "$(fstr "${1?}" "${3?}" "${4?}" "${6?}")" \
           '^'        "${2:?}"  '$'        ''    "${5?}"  ''    '' \
           '^'        "$2"      "$rpunct"  ''    "$5"     '\3'  '' \
           "$lpunct"  "$2"      '$'        '\1'  "$5"     ''    '' \
           "$lpunct"  "$2"      "$rpunct"  '\1'  "$5"     '\3'  'g'
}

# We only want to colorize the text to the left of "@ok{".  Store all
# text to the right of "@ok{" in the hold space; at the end, use a
# substitution to remove that text from the pattern space.
printf '%s\n' \
       '/^@lisp$/,/^@end lisp$/ {' \
       '  /@ok{/ {' \
       '  h' \
       '  x' \
       '  s/^.*@ok{//' \
       '  x' \
       '}' \
       '/#./ {'

# Wrap each #\char in @char{}.
for s in $chars 'x[[:xdigit:]]\{1,\}' 'u[[:xdigit:]]\{4\}' 'U[[:xdigit:]]\{8\}'; do
    gensub '#\\\\' "$s" '' '@char{@value{num}@backslashchar{}' '\2' '}'
done

for pair in $char_refs; do
    char="${pair%%-*}"
    ref="${pair##*-}"
    case "$char" in
        \\) char='\\\\' ;;
        \[) char='\\\[' ;;
        \*) char='\\*' ;;
        .) char='\\.' ;;
    esac
    gensub '#\\\\' "$char" '' '@char{@value{num}@backslashchar{}@value{' "$ref" '}}'
done

# Wrap each Boolean in @boolean{}.
for s in true false f t; do
    gensub '#' "$s" '' '@boolean{@value{num}' "$s" '}'
done

_rpunct="$rpunct"; rpunct='.'

# Wrap each #& in @box{}.
gensub '#' '&' '' '@box{@value{num}' '@value{amp}' '}'

# Wrap each #!sharp in @sharp{}.
for s in $sharps; do
    gensub '#!' "$s" '' '@sharp{@value{num}@value{excl}' "$s" '}'
done

# Wrap single-character chars in @char{}
gensub '#\\\\' '.' '' '@char{@value{num}@backslashchar{}' '\2' '}'

rpunct="$_rpunct"

# Wrap each #serial object identifier in @serial{}.
gensub '#' '[[:digit:]]\{1,\}' '' '@serial{@value{num}' '\2' '}'

# Wrap each keyword: in @keyword{}.
gensub '' "$identifier_chars\\{1,\\}" ':' '@keyword{' '\2' '@value{colon}}'

_lpunct="$lpunct"; lpunct='.'

# Avoid dimming empty vectors.
for s in $homogeneous_vectors ''; do
    gensub "#$s(" '[[:blank:]]*' ')' "@value{num}$s@value{lpar}" '\2' '@value{rpar}'
done

printf '%s\n' '}'

# Avoid dimming the empty list.
gensub "(" '[[:blank:]]*' ')' "@value{lpar}" '\2' '@value{rpar}'

lpunct="$_lpunct"

_rpunct="$rpunct"; rpunct='.';

# Dim vector-beginning delimiters.
for s in $homogeneous_vectors; do
    gensub '#' "$s" '(' '@paren{@value{num}' '\2' '@value{lpar}}'
done
gensub '#' '(' '' '@paren{@value{num}' '@value{lpar}}' ''

# Dim circular lists.
gensub '#' '[[:digit:]]\{1,\}' '=(' '@paren{@value{num}' '\2' \
       '@value{equals}@value{lpar}}'

rpunct="$_rpunct"

# Wrap each special syntactic form in @syntax{}.
for s in $syntax; do
    case "$s" in
        *\**) form="${s%%\**}\\*${s##*\*}" ;;
        *) form="$s" ;;
    esac
    gensub '' "$form" '' '@syntax{' '\2' '}'
done

_rpunct="$rpunct"; rpunct='.'; _lpunct="$lpunct"; lpunct='.'

gensub '' '\\"' '' '@backslashchar{}' '@value{quot}' ''

# Dim other "punctuation" characters.
printf '%s\n' \
       "s/'/@paren{@value{apos}}/g" \
       's/,/@paren{@value{comma}}/g' \
       's/`/@paren{@value{grave}}/g' \
       's/\[/@paren{@value{lbrack}}/g' \
       's/(/@paren{@value{lpar}}/g' \
       's/]/@paren{@value{rbrack}}/g' \
       's/)/@paren{@value{rpar}}/g' \
       's/\./@paren{@value{period}}/g' \
       's/@atchar{}/@paren{@atchar}/g'

lpunct="$_lpunct"; rpunct="$_rpunct"

# Wrap each "string" in @string{}.
printf '  %s\n' 's/"\([^"]*\)"/@string{@value{quot}\1@value{quot}}/g'

# Add back the part we've been keeping in the hold space.
printf '%s\n' \
       '/@ok{/ {' \
       '  s/@ok{.*$/@ok{/' \
       '  G' \
       '  s/\n//' \
       '}'

# Wrap comments last so they may occur to the right of "@ok{..}".
printf '%s\n' 's/\([[:blank:]]\);\(.*\)$/\1@codecomment{;\2}/'

# Replace literal character occurrences with character references.
for pair in $char_refs; do
    char="${pair%%-*}"
    ref="${pair##*-}"
    case "$char" in
        \\) char='\\' ;;
        \[) char='\[' ;;
        \*) char='\*' ;;
        .) char='\.' ;;
    esac
    printf 's/%s/@value{%s}/g\n' "$char" "$ref"
done

printf '%s\n' '}'
