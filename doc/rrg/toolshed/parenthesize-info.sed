# Copyright (c) 2024 by Macon Gambill, all rights reserved.
/^ -- ([-!#$%&*+./:<=>?@^_~'[:alnum:]]+ library )?(procedure|syntax): [-!#$%&*+./:<=>?@^_~'[:alnum:]]/,/^$/ {
  /^($| {5,9}[[:graph:]]| -- auxiliary syntax: )/ {
    x
    /^$/ {
      x
      p
      d
    }
    s/$/\)/
    s/\(([[:punct:]]{1,2}(constant|datum|variable)[[:punct:]])\)/\1/g
    p
    s/.*//
    x
  }
  /^ {10}/ {
    H
    d
  }
  /^ -- ([-!#$%&*+./:<=>?@^_~'[:alnum:]]+ library )?(procedure|syntax): [-!#$%&*+./:<=>?@^_~'[:alnum:]]/ {
    s/^ -- ([-!#$%&*+./:<=>?@^_~'[:alnum:]]+ library )?(procedure|syntax): /&\(/
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
