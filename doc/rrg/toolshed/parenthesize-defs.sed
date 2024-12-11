# Copyright (c) 2024 by Macon Gambill, all rights reserved.
/^<dt class="deffnx\{0,1\}[" ].*<strong class="def-name">/ {
    s/\(<strong class="def-name"\)/<span class="def-paren">\&#x0028;<\/span>\1/
    s/\(<a class="copiable-link"\)/<span class="def-paren">\&#x0029;<\/span>\1/
}
/^<dt class="deftypefn[" ].*<strong class="def-name">/ {
    s/\(<strong class="def-name"\)/<span class="def-paren">\&#x0028;<\/span>\1/
    s/\(<a class="copiable-link"\)/<span class="def-paren">\&#x0029;<\/span>\1/
}
/^<dl class="first-defblock">/,/<\/dl>/ {
    s/\(<span class="category-def">procedure: <\/span>\)\(<strong class="def-name"\)/\1<span class="def-paren">\&#x0028;<\/span>\2/
    s/\(<\/var>\)\(<\/dt>\)/\1<span class="def-paren">\&#x0029;<\/span>\2/
}
