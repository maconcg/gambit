# Copyright (c) 2024 by Macon Gambill, All Rights Reserved.
readonly syntax="$(<toolshed/data/syntax-words)"

# We only want to colorize the text to the left of "@ok{".  Store all
# text to the right of "@ok{" in the hold space; at the end, use a
# substitution to remove that text from the pattern space.
printf '%s\n' '/^@lisp$/,/^@end lisp$/ {
    /@ok{/ {
        h
        x
        s/^.*@ok{//
        x
    }'

# Wrap each character in @char{}.
printf '%s\n' '    /#\\/ {
        s/#\\\([[:graph:]]\)$/@char{\1}/g
        s/#\\\([[:graph:]]\)\([])[:blank:]]\)/@char{\1}\2/g
        s/#\\\([[:lower:]]\{2,\}\)$/@char{\1}/g
        s/#\\\([[:lower:]]\{2,\}\)\([])[:blank:]]\)/@char{\1}\2/g
        s/#\\\(x[[:xdigit:]]\{1,\}\)$/@char{\1}/g
        s/#\\\(x[[:xdigit:]]\{1,\}\)\([])[:blank:]]\)/@char{\1}\2/g
    }'

# Wrap each #!sharp identifier in @sharp{}.
for s in eof key optional rest void; do
    printf '    %s\n    %s\n' "s/^#!$s/@sharp{@hashchar{}@U{0021}$s}/" \
           "s/\(['([:blank:]]\)#!$s/\1@sharp{@hashchar{}@U{0021}$s}/g"
done

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
printf '    %s\n' \
       's/\\"/@backslashchar{}@U{0022}/g' \
       's/"\([^"]*\)"/@string{"\1"}/g'

# Dim most parens/similar syntactic tokens.
printf '    %s\n' \
       's/^#u8(\([[:blank:]]*\))/@hashchar{}u8@U{0028}\1@U{0029}/g' \
       's/^#(\([[:blank:]]*\))/@hashchar{}@U{0028}\1@U{0029}/g' \
       's/^(\([[:blank:]]*\))/@U{0028}\1@U{0029}/g' \
       "s/\([,\`'([:blank:][]\)#u8(\([[:blank:]]*\))/\1@hashchar{}u8@U{0028}\2@U{0029}/g" \
       "s/\([,\`'([:blank:][]\)#(\([[:blank:]]*\))/\1@hashchar{}@U{0028}\2@U{0029}/g" \
       "s/\([,\`'([:blank:][]\)(\([[:blank:]]*\))/\1@U{0028}\2@U{0029}/g" \
       "s/'/@paren{@U{0027}}/g" \
       's/#u8(/@paren{@hashchar{}u8@U{0028}}/g' \
       's/#(/@paren{@hashchar{}@U{0028}}/g' \
       's/(/@paren{@U{0028}}/g' \
       's/)/@paren{@U{0029}}/g' \
       's/`/@paren{@U{0060}}/g' \
       's/,/@paren{@comma{}}/g' \
       's/@atchar{}/@paren{@atchar{}}/g'

# Add back the part we've been keeping in the hold space.
printf '    %s\n' '/@ok{/ {
        s/@ok{.*$/@ok{/
        G
        s/\n//
    }'

# Wrap comments last so they may occur to the right of "@ok{..}".
printf '    %s\n' 's/\([[:blank:]]\);\(.*\)$/\1@codecomment{;\2}/
}'
