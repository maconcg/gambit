#| TODO:

Types
=====
boolean:           #f, #false, #t, #true
datum comment:     #;
datum label:       #<n>=
datum reference:   #<n>#
directive:         #!fold-case, #!no-fold-case
exactness:         #e, #i
hvector:           s8, u8, s16, u16, s32, u32, s64, u64, f32, f64
keyword:           kw:
nested comment:    #|...|#
serial reference:  #<n>
sharp:             #!eof, #!void, #!optional, #!rest, #!key
radix:             #x, #d, #o, #b
vector:            #(...)

Other
=====
clean way to backtrack (probably just set-category! will work)
|#

(define digit-16 (char-set->list char-set:hex-digit))

(define digit-10 (char-set->list (char-set-difference char-set:hex-digit
                                                      char-set:letter)))

(define digit-8 (filter (λ (c) (not (member c (list #\8 #\9) char=?)))
                        digit-10))

(define digit-2 (string->list "01"))

(define-record-type adorned-char
  (construct-adorned-char char category message)
  adorned-char?
  (char select-char set-char!)
  (category select-category set-category!)
  (message select-message set-message!))

(define adorn-char
  (case-lambda
    ((c) (construct-adorned-char c (categorize-char c) (compose-message c)))
    ((c category) (construct-adorned-char c category (compose-message c)))
    ((c category message) (construct-adorned-char c category message))))

(define (->char maybe-adorned-char)
  (cond ((char? maybe-adorned-char) maybe-adorned-char)
        ((adorned-char? maybe-adorned-char) (select-char maybe-adorned-char))
        (else (error "neither char? nor adorned-char?:" maybe-adorned-char))))

(define categorize-char
  (case-lambda
    ((maybe-adorned-char)
     (case (->char maybe-adorned-char)
       (( #\'      #\`    #\,       ) 'abbrev)
       (( #\{      #\}              ) 'brace)
       (( #\[      #\]              ) 'bracket)
       (( #\.                       ) 'dot)
       (( #\|                       ) 'identifier)
       (( #\;                       ) 'line-comment)
       (( #\#                       ) 'tbd)
       (( #\(      #\)              ) 'paren)
       (( #\λ                       ) 'special)
       (( #\"                       ) 'string)
       (( #\space  #\tab  #\newline ) 'whitespace)
       (else 'tbd)))
    ((next prev)
     (case (select-message prev)
       ((char identifier string) => identity)
       ((line-comment) (if (char=? #\newline (->char next))
                           'whitespace
                           'line-comment))
       ((octothorpe) (case (->char next)
                       (( #\&                ) 'box)
                       (( #\\                ) 'char)
                       (( #\!                ) 'directive-or-sharp-object)
                       (( #\;                ) 'datum-comment)
                       (( #\e  #\i           ) 'exactness)
                       (( #\|                ) 'nested-comment)
                       (( #\b  #\d  #\o  #\x ) 'radix)
                       (( #\f  #\s  #\u      ) 'hvector)
                       (( #\(                ) 'vector)
                       (( #\0 #\1 #\2 #\3
                          #\4 #\5 #\6 #\7
                          #\8 #\9            ) 'label-or-serial)
                       (else #f)))
       (else (categorize-char next))))))

(define compose-message
  (case-lambda
    ((maybe-adorned-char)
     (case (->char maybe-adorned-char)
       (( #\| ) 'identifier)
       (( #\; ) 'line-comment)
       (( #\# ) 'octothorpe)
       (( #\" ) 'string)
       (else #f)))
    ((next prev)
     (case (select-message prev)
       ((identifier) (if (and (char=? #\| (->char next))
                              (not (char=? #\\ (->char prev))))
                         #f
                         'identifier))
       ((line-comment) (if (char=? #\newline (->char next))
                           #f
                           'line-comment))
       ((octothorpe) (case (->char next)
                       (( #\&               ) 'box-content)
                       (( #\\               ) 'char)
                       (( #\!               ) 'directive-or-sharp-object)
                       (( #\;               ) 'datum-comment)
                       (( #\e  #\i          ) 'exactness)
                       (( #\|               ) 'nested-comment)
                       (( #\b  #\d  #\o  #\x) 'radix)
                       (( #\f  #\s  #\u     ) 'hvector)
                       (( #\(               ) 'vector)
                       (( #\0 #\1 #\2 #\3
                          #\4 #\5 #\6 #\7
                          #\8 #\9           ) 'label-or-serial)
                       (else #f)))
       ((string) (if (and (char=? #\" (->char next))
                          (not (char=? #\\ (->char prev))))
                     #f
                     'string))
       (else (compose-message (->char next)))))))

(define (revise-previous top rest)
  (call/cc (lambda (done)
             (let ((top-category (select-category top)))
               (for-each (lambda (ac)
                           (let ((category (select-category ac)))
                             (if (eq? 'tbd category)
                                 (let ((message (select-message ac)))
                                   (if message
                                       (set-category! ac top-category)
                                       (set-category! ac 'default)))
                                 (done #t))))
                         rest)))))

(define (adorn-datum datum)
  (let loop ((adorned '()) (unadorned datum))
    (cond ((null? unadorned) (reverse adorned))
          ((null? adorned) (let ((first (adorn-char (car unadorned))))
                             (set-message! first (compose-message first))
                             (set-category! first (categorize-char first))
                             (loop (cons first adorned)
                                   (cdr unadorned))))
          (else (let ((next (adorn-char (car unadorned)))
                      (prev (car adorned)))
                  (set-message! next (compose-message next prev))
                  (set-category! next (categorize-char next prev))
                  (revise-previous next adorned)
                  (loop (cons next adorned)
                        (cdr unadorned)))))))
