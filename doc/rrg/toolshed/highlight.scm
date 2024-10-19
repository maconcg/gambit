#| TODO:

Types
=====
boolean:           #f, #false, #t, #true
box:               #&
char:              #\
datum comment:     #;
directive:         #!fold-case, #!no-fold-case
exactness:         #e, #i
hvector:           s8, u8, s16, u16, s32, u32, s64, u64, f32, f64
keyword:           kw:
nested comment:    #|...|#
serial reference:  #[[:digit:]]
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
       (( #\#                       ) 'octothorpe)
       (( #\(      #\)              ) 'paren)
       (( #\λ                       ) 'special)
       (( #\"                       ) 'string)
       (( #\space  #\tab  #\newline ) 'whitespace)
       (else 'default)))
    ((next prev)
     (or (select-message prev) (categorize-char (->char next))))))

(define compose-message
  (case-lambda
    ((maybe-adorned-char)
       (case (->char maybe-adorned-char)
         (( #\| ) 'identifier)
         (( #\; ) 'line-comment)
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
       ((string) (if (and (char=? #\" (->char next))
                          (not (char=? #\\ (->char prev))))
                     #f
                     'string))
       (else (compose-message (->char next)))))))

(define (adorn-datum datum)
  (let loop ((adorned '()) (unadorned datum))
    (cond ((null? unadorned) (reverse adorned))
          ((null? adorned) (let ((first (adorn-char (car unadorned))))
                             (set-category! first (categorize-char first))
                             (set-message! first (compose-message first))
                             (loop (cons first adorned)
                                   (cdr unadorned))))
          (else (let ((next (adorn-char (car unadorned)))
                      (prev (car adorned)))
                  (set-category! next (categorize-char next prev))
                  (set-message! next (compose-message next prev))
                  (loop (cons next adorned)
                        (cdr unadorned)))))))
