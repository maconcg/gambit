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
|#
#|---------------------------------------------------------------------------|#
(define-record-type adorned-char
  (make-adorned-char char kind message)
  adorned-char?
  (char get-char set-char!)
  (kind get-kind set-kind!)
  (message get-message set-message!))

(define adorn-char
  (case-lambda
    ((c) (make-adorned-char c (choose-kind c) (compose-message c)))
    ((c kind) (make-adorned-char c kind (compose-message c)))
    ((c kind message) (make-adorned-char c kind message))))

(define (->char char-or-ac)
  (cond ((char? char-or-ac) char-or-ac)
        ((adorned-char? char-or-ac) (get-char char-or-ac))
        (else (error "neither char? nor adorned-char?:" char-or-ac))))

(define (message-in list-of-symbols boolean-or-symbol-or-ac)
  (let ((ml (memq boolean-or-symbol-or-ac list-of-symbols)))
    (if ml (car ml) #f)))

(define (char-in? list-of-chars char-or-ac)
  (let* ((char (->char char-or-ac)))
    (not (not (member char list-of-chars char=?)))))
#|---------------------------------------------------------------------------|#
(define (ampersand?   c) (char=?    #\&                           c))
(define (apostrophe?  c) (char=?    #\'                           c))
(define (at?          c) (char=?    #\@                           c))
(define (backslash?   c) (char=?    #\\                           c))
(define (bar?         c) (char=?    #\|                           c))
(define (brace?       c) (char-in? '( #\{        #\}            ) c))
(define (bracket?     c) (char-in? '( #\[        #\]            ) c))
(define (colon?       c) (char=?    #\:                           c))
(define (comma?       c) (char=?    #\,                           c))
(define (dot?         c) (char=?    #\.                           c))
(define (exclamation? c) (char=?    #\!                           c))
(define (grave?       c) (char=?    #\`                           c))
(define (lbrace?      c) (char=?    #\{                           c))
(define (lbracket?    c) (char=?    #\[                           c))
(define (lparen?      c) (char=?    #\(                           c))
(define (newline?     c) (char=?    #\newline                     c))
(define (octothorpe?  c) (char=?    #\#                           c))
(define (paren?       c) (char-in? '( #\(        #\)            ) c))
(define (quotation?   c) (char=?    #\"                           c))
(define (rbrace?      c) (char=?    #\}                           c))
(define (rbracket?    c) (char=?    #\]                           c))
(define (rparen?      c) (char=?    #\)                           c))
(define (semicolon?   c) (char=?    #\;                           c))
(define (tilde?       c) (char=?    #\~                           c))
(define (whitespace?  c) (char-in? '( #\newline  #\space  #\tab ) c))
#|---------------------------------------------------------------------------|#
(define (digit2?  c) (char-in? '( #\0 #\1 ) c))
(define (digit8?  c) (char-in? '( #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 ) c))
(define (digit10? c) (char-in? '( #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 ) c))
(define (digit16? c) (char-in? '( #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9
                                  #\a #\b #\c #\d #\e #\f
                                  #\A #\B #\C #\D #\E #\F ) c))
#|---------------------------------------------------------------------------|#
(define (abbrev-first? c)
  (or (apostrophe? c) (grave? c) (comma? c)))

(define (delimiter? c)
  (or (bar? c) (paren? c) (semicolon? c) (whitespace? c)))

(define (exactness-char? c)
  (char-in? '( #\e #\i ) c))

(define (exponent-or-precision-char? c)
  (char-in? '( #\e #\s #\f #\d #\l
               #\E #\S #\F #\D #\L ) c))

(define (hvector-letter?)
  (char-in? '( #\f #\s #\u ) c))

(define (radix-char? c)
  (char-in? '( #\x #\d #\o #\b ) c))
#|---------------------------------------------------------------------------|#
(define choose-kind
  (case-lambda
    ((next)
     (let ((nc (->char next)))
       (cond ((abbrev-first? nc) 'abbrev)
             ((backslash?    nc) 'infix)
             ((digit10?      nc) 'number10)
             ((bar?          nc) 'identifier)
             ((brace?        nc) 'brace)
             ((bracket?      nc) 'bracket)
             ((dot?          nc) 'dot)
             ((paren?        nc) 'paren)
             ((quotation?    nc) 'string)
             ((semicolon?    nc) 'line-comment)
             ((whitespace?   nc) 'whitespace)
             (else               'tbd))))
    ((next rest)
     (let* ((nc (get-char next))
            (prev (car rest))
            (pm (get-message prev)))
       (cond ((or (eq? 'identifier pm) (eq? 'string pm)) pm)
             ((eq? 'line-comment pm)
              (if (char=? #\newline nc)
                  (choose-kind nc)
                  'line-comment))
             ((eq? 'abbrev-if-@ pm)
              (if (at? nc)
                  'abbrev
                  (choose-kind nc)))
             ((eq? 'special-start pm)
              (cond ((ampersand?         nc) 'box)
                    ((backslash?         nc) 'char)
                    ((bar?               nc) 'nested-comment)
                    ((char=? #\f         nc) 'tbd)
                    ((char=? #\t         nc) 'tbd)
                    ((char-in '(#\s #\u) nc) 'tbd)
                    ((digit10?           nc) 'tbd)
                    ((exactness-char?    nc) 'number)
                    ((exclamation?       nc) 'tbd)
                    ((lparen?            nc) 'vector)
                    ((radix-char?        nc) 'number)
                    ((semicolon?         nc) 'datum-comment)
                    (else                    'invalid)))
             ((eq? 'true pm)
              (let ((pc (get-char prev)))
                (if (delimiter? nc)
                    (begin (revise rest (if (char=? #\t pc)
                                            'boolean
                                            'invalid))
                           (choose-kind nc))
                    (cond ((and (char=? #\t pc) (char=? #\r nc)) 'tbd)
                          ((and (char=? #\r pc) (char=? #\u nc)) 'tbd)
                          ((and (char=? #\u pc) (char=? #\e nc))
                           (revise rest 'boolean)
                           'boolean)
                          (else (revise rest 'invalid)
                                'invalid)))))
             (else
              (choose-kind nc)))))))

(define compose-message
  (case-lambda
    ((next)
     (let ((nc (->char next)))
       (cond ((bar?       nc) 'identifier)
             ((comma?      nc) 'abbrev-if-@)
             ((octothorpe? nc) 'special-start)
             ((quotation?  nc) 'string)
             ((semicolon?  nc) 'line-comment)
             (else              #f))))
    ((next rest)
     (let* ((nc (get-char next))
            (prev (car rest))
            (pc (get-char prev))
            (pm (get-message prev)))
       (cond ((eq? 'identifier pm) (if (and (char=? #\| nc)
                                                    (not (char=? #\\ pc)))
                                               #f
                                               'identifier))
             ((eq? 'line-comment pm) (if (char=? #\newline nc)
                                                 #f
                                                 'line-comment))
             ((eq? 'string pm) (if (and (char=? #\" nc)
                                                (not (char=? #\\ pc)))
                                           #f
                                           'string))
             ((eq? 'special-start pm)
              (cond ((ampersand?         nc) #f)
                    ((backslash?         nc) 'char)
                    ((bar?               nc) 'nested-comment)
                    ((char=? #\f         nc) 'false-or-fvector)
                    ((char=? #\t         nc) 'true)
                    ((char-in '(#\s #\u) nc) 'svector-or-uvector)
                    ((digit10?           nc) 'label-or-reference-or-serial)
                    ((exactness-char?    nc) 'radix-or-digit10)
                    ((exclamation?       nc) 'directive-or-sharp-object)
                    ((lparen?            nc) 'vector)
                    ((radix-char?        nc) (cond ((char=? #\x nc)
                                                    'exactness-or-digit16)
                                                   ((char=? #\d nc)
                                                    'exactness-or-digit10)
                                                   ((char=? #\o nc)
                                                    'exactness-or-digit8)
                                                   ((char=? #\b nc)
                                                    'exactness-or-digit2)
                                                   (else 'invalid)))
                    ((semicolon?         nc) 'datum-comment)
                    (else                    'invalid)))
             ((eq? 'true pm)
              (cond ((and (char=? #\t pc) (delimiter? nc))
                     (compose-message next))
                    ((and (char=? #\t pc) (char=? #\r nc)) 'true)
                    ((and (char=? #\r pc) (char=? #\u nc)) 'true)
                    (else #f)))
             (else (compose-message next)))))))

(define (revise datum revised-kind)
  (call/cc (lambda (done)
             (for-each (lambda (adorned-char)
                         (let ((kind (get-kind adorned-char))
                               (message (get-message adorned-char)))
                           (cond ((eq? 'tbd kind)
                                  (if message
                                      (set-kind! adorned-char revised-kind)
                                      (set-kind! adorned-char 'default)))
                                 (else (done #t)))))
                       datum))))

(define (adorn-datum datum)
  (let loop ((adorned '()) (unadorned datum))
    (cond ((null? unadorned) (reverse adorned))
          ((null? adorned) (loop (cons (adorn-char (car unadorned)) adorned)
                                 (cdr unadorned)))
          (else (let ((next (adorn-char (car unadorned))))
                  (set-message! next (compose-message next adorned))
                  (set-kind! next (choose-kind next adorned))
                  (when (delimiter? (->char next))
                    (revise adorned (get-kind next)))
                  (loop (cons next adorned) (cdr unadorned)))))))
