# Copyright (c) 2024 by Macon Gambill, all rights reserved.
/^ -- ([-!$%&*+./:<=>?@^_~[:alpha:]]+ library )?(procedure|syntax): [-!$%&*+./:<=>?@^_~[:alpha:]]/,/^$/ {
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
  /^ -- ([-!$%&*+./:<=>?@^_~[:alpha:]]+ library )?(procedure|syntax): [-!$%&*+./:<=>?@^_~[:alpha:]]/ {
    s/^ -- ([-!$%&*+./:<=>?@^_~[:alpha:]]+ library )?(procedure|syntax): /&\(/
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
