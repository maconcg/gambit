# Copyright (c) 2024 by Macon Gambill, all rights reserved.

/^<dt class="deffnx\{0,1\}[" ].*<strong class="def-name">/ {
  s/\(<strong class="def-name"\)/<span class="def-paren"><code class="t">\&#x0028;<\/code><\/span>\1/
  s/\(<a class="copiable-link"\)/<span class="def-paren"><code class="t">\&#x0029;<\/code><\/span>\1/
}

/^<dt class="deftypefnx\{0,1\}[" ].*<strong class="def-name">/ {
  h
  s/\(<strong class="def-name"\)/<span class="def-paren"><code class="t">\&#x0028;<\/code><\/span>\1/
  s/\(<a class="copiable-link"\)/<span class="def-paren"><code class="t">\&#x0029;<\/code><\/span>\1/
  /<span class="category-def">auxiliary syntax:/ {
    /<strong class="def-name">else<\/strong>/x
    /<strong class="def-name">=&gt;<\/strong>/x
    /<strong class="def-name">\.\.\.<\/strong>/x
    /<strong class="def-name">_<\/strong>/x
  }
}

/^<dl class="first-defblock">/,/<\/dl>/ {
  s/\(<span class="category-def">procedure: <\/span>\)\(<strong class="def-name"\)/\1<span class="def-paren"><code class="t">\&#x0028;<\/code><\/span>\2/
  s/\(<\/var>\)\(<\/dt>\)/\1<span class="def-paren"><code class="t">\&#x0029;<\/code><\/span>\2/
}

/^<dt class="deftypeline[" ].*<strong class="def-name">/ {   
  /<span class="syntax">quote<\/span><\/strong>/ {
    s/\(<strong class="def-name">\)/<span class="def-paren"><code class="t">\&#x0028;<\/code><\/span>\1/
    s/\(<\/code><\/dt>\)/<span class="def-paren"><code class="t">\&#x0029;<\/code><\/span>\1/
  }
  /<span class="syntax">quasiquote<\/span><\/strong>/ {
    s/\(<strong class="def-name">\)/<span class="def-paren"><code class="t">\&#x0028;<\/code><\/span>\1/
    s/\(<\/code><\/dt>\)/<span class="def-paren"><code class="t">\&#x0029;<\/code><\/span>\1/
  }
}
