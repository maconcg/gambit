# Copyright (c) 2024 by Macon Gambill, all rights reserved.
/^ -- ([-!#$%&*+./:<=>?@^_~[:alpha:]]+ library )?(procedure|syntax): [-!#$%&*+./:<=>?@^_~[:alpha:]]/,/^$/ {
  /^($| {5,9}[[:graph:]]| -- auxiliary syntax: )/ {
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
  /^ {10}/ {
    H
    d
  }
  /^ -- ([-!#$%&*+./:<=>?@^_~[:alpha:]]+ library )?(procedure|syntax): [-!#$%&*+./:<=>?@^_~[:alpha:]]/ {
    s/^ -- ([-!#$%&*+./:<=>?@^_~[:alpha:]]+ library )?(procedure|syntax): /&\(/
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
