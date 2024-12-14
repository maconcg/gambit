# Copyright (c) 2024 by Macon Gambill, all rights reserved.
/^ -- ([[:graph:]]+ library )?(procedure|syntax): [[:lower:]]/,/^$/ {
  /^($| -- auxiliary syntax: )/ {
    x
    /^$/ {
      x
      p
      d
    }
    s/$/\)/
    p
    s/.*//
    x
  }
  /^   / {
    H
    d
  }
  /^ -- ([[:graph:]]+ library )?(procedure|syntax): [[:lower:]]/ {
    s/^ -- ([[:graph:]]+ library )?(procedure|syntax): /&\(/
    x
    /^$/ {
      d
    }
    s/$/\)/
    x
    H
    d
  }
}
