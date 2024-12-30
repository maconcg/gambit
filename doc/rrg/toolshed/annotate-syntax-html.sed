# Copyright (c) 2024 by Macon Gambill, all rights reserved.

/^<dt class="deftypefnx\{0,1\}[" ].*<strong class="def-name">/ {
  s/\(<span><span class="def-paren"><code class="t">&#x0028;<\/code><\/span>\)\(<strong class="def-name">[^<]*<\/strong>\)/\1<span class="syntax">\2<\/span>/
  /<span class="category-def">auxiliary syntax: / {
    s/<strong class="def-name">else<\/strong>/<span class="aux">&<\/span>/
    s/<strong class="def-name">=&gt;<\/strong>/<span class="aux">&<\/span>/
  }
}
