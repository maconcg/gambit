#| TODO:

Types
=====
boolean:           #f, #false
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
;-----------------------------------------------------------------------------;
(define-record-type adorned-char
  (make-adorned-char char kind message)
  adorned-char?
  (char get-char set-char!)
  (kind get-kind set-kind!)
  (message get-message set-message!))

(define (adorn-char char)
  (make-adorned-char char (choose-kind char) (compose-message char)))

(define (->char char-or-ac)
  (cond ((char? char-or-ac) char-or-ac)
        ((adorned-char? char-or-ac) (get-char char-or-ac))
        (else (error "neither char? nor adorned-char?:" char-or-ac))))

(define (char-in? list-of-chars char)
  (not (not (member char list-of-chars char=?))))
;-----------------------------------------------------------------------------;
(define (ampersand?   c) (char=?       #\&                          c))
(define (apostrophe?  c) (char=?       #\'                          c))
(define (at?          c) (char=?       #\@                          c))
(define (backslash?   c) (char=?       #\\                          c))
(define (bar?         c) (char=?       #\|                          c))
(define (brace?       c) (char-in? '(  #\{        #\}             ) c))
(define (bracket?     c) (char-in? '(  #\[        #\]             ) c))
(define (colon?       c) (char=?       #\:                          c))
(define (comma?       c) (char=?       #\,                          c))
(define (dot?         c) (char=?       #\.                          c))
(define (exclamation? c) (char=?       #\!                          c))
(define (grave?       c) (char=?       #\`                          c))
(define (lbrace?      c) (char=?       #\{                          c))
(define (lbracket?    c) (char=?       #\[                          c))
(define (lparen?      c) (char=?       #\(                          c))
(define (newline?     c) (char=?       #\newline                    c))
(define (octothorpe?  c) (char=?       #\#                          c))
(define (paren?       c) (char-in? '(  #\(        #\)             ) c))
(define (quotation?   c) (char=?       #\"                          c))
(define (rbrace?      c) (char=?       #\}                          c))
(define (rbracket?    c) (char=?       #\]                          c))
(define (rparen?      c) (char=?       #\)                          c))
(define (semicolon?   c) (char=?       #\;                          c))
(define (tilde?       c) (char=?       #\~                          c))
(define (whitespace?  c) (char-in? '(  #\newline  #\space  #\tab  ) c))
;-----------------------------------------------------------------------------;
(define (digit2?  c) (char-in? '( #\0 #\1 ) c))
(define (digit8?  c) (char-in? '( #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 ) c))
(define (digit10? c) (char-in? '( #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 ) c))
(define (digit16? c) (char-in? '( #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9
                                  #\a #\b #\c #\d #\e #\f
                                  #\A #\B #\C #\D #\E #\F ) c))
;-----------------------------------------------------------------------------;
(define (abbrev-first? c)
  (or (apostrophe? c) (grave? c) (comma? c)))

(define (delimiter? c)
  (or (bar? c) (paren? c) (quotation? c) (semicolon? c) (whitespace? c)))

(define (exactness-char? c)
  (char-in? '( #\e #\i ) c))

(define (exponent-or-precision-char? c)
  (char-in? '( #\e #\s #\f #\d #\l
               #\E #\S #\F #\D #\L ) c))

(define (hvector-letter? c)
  (char-in? '( #\f #\s #\u ) c))

(define named-chars
  (list "alarm" "backspace" "delete" "esc" "escape" "linefeed" "newline"
        "nul" "null" "page" "return" "space" "tab" "vtab"))

(define named-char-firsts
  (letrec ((dedup (lambda (new old)
                    (cond ((null? old) new)
                          ((member (car old) new char=?)
                           (dedup new (cdr old)))
                          (else (dedup (cons (car old) new) (cdr old)))))))
    (list-sort char<? (dedup '() (map car (map string->list named-chars))))))

(define (radix-char? c)
  (char-in? '( #\x #\d #\o #\b ) c))
;-----------------------------------------------------------------------------;
(define (preceding-tbd ac-list)
  (list->string (let loop ((new '()) (old ac-list))
                  (if (null? old)
                      new
                      (let ((first (car old)))
                        (if (eq? 'tbd (get-kind first))
                            (loop (cons (get-char first) new)
                                  (cdr old))
                            new))))))

(define (tbd-names-char? ac-list)
  (member (preceding-tbd ac-list)
          (map (lambda (s) (string-append "#\\" s)) named-chars)
          string=?))

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
     (guard (kind
             ((symbol? kind) (revise rest kind)))
       (let* ((pick (make-parameter #f))
              (nc (get-char next))
              (prev (car rest))
              (pk (get-kind prev))
              (pm (get-message prev)))
         (parameterize ((pick (if (and (not (delimiter? nc))
                                       (or (symbol=? pk 'invalid)
                                           (eq? pm 'invalid)))
                                  (lambda (symbol) (raise 'invalid))
                                  (lambda (symbol) (raise symbol)))))
           (cond ((and (eq? 'invalid pm) (not (delimiter? nc)) 'invalid))
                 ((eq? 'char-init pm) 'tbd)
                 ((eq? 'char-first pm) (if (delimiter? nc)
                                           (begin (revise rest 'char)
                                                  (choose-kind nc))
                                           'tbd))
                 ((or (eq? 'identifier pm) (eq? 'string pm)) pm)
                 ((eq? 'char-named pm) (if (delimiter? nc)
                                           (begin
                                             (revise rest
                                                     (if (tbd-names-char? rest)
                                                         'char
                                                         'invalid))
                                             (choose-kind nc))
                                           'tbd))
                 ((eq? 'line-comment pm) (if (char=? #\newline nc)
                                             (choose-kind nc)
                                             'line-comment))
                 ((eq? 'abbrev-if-@ pm) (if (at? nc)
                                            'abbrev
                                            (choose-kind nc)))
                 ((eq? 'special-start pm)
                  (cond ((ampersand?          nc) ((pick) 'box))
                        ((backslash?          nc) 'tbd)
                        ((bar?                nc) ((pick) 'nested-comment))
                        ((char=? #\f          nc) 'tbd)
                        ((char=? #\t          nc) 'tbd)
                        ((char-in? '(#\s #\u) nc) 'tbd)
                        ((digit10?            nc) 'tbd)
                        ((exactness-char?     nc) 'tbd)
                        ((exclamation?        nc) 'tbd)
                        ((lparen?             nc) 'tbd)
                        ((radix-char?         nc) 'tbd)
                        ((semicolon?          nc) ((pick) 'datum-comment))
                        (else                     ((pick) 'invalid))))
                 ((eq? 'true pm)
                  (let ((pc (get-char prev)))
                    (if (and (delimiter? nc) (char=? #\t pc))
                        (begin (revise rest 'boolean)
                               (choose-kind nc))
                        (cond ((and (char=? #\t pc) (char=? #\r nc)) 'tbd)
                              ((and (char=? #\r pc) (char=? #\u nc)) 'tbd)
                              ((and (char=? #\u pc) (char=? #\e nc)) 'tbd)
                              ((and (char=? #\e pc) (delimiter? nc))
                               (revise rest 'boolean)
                               (choose-kind nc))
                              ((delimiter? nc)
                               (revise rest 'invalid)
                               (choose-kind nc))
                              (else ((pick) 'invalid))))))
                 ((and (not pm) (delimiter? nc) (symbol=? 'tbd pk))
                  ((pick) (choose-kind nc)))
                 (else
                  (choose-kind nc)))))))))

(define compose-message
  (case-lambda
    ((next)
     (let ((nc (->char next)))
       (cond ((bar?        nc) 'identifier)
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
       (cond ((and (eq? 'invalid pm) (not (delimiter? nc)) 'invalid))
             ((eq? 'char-init pm) 'char-first)
             ((eq? 'char-first pm)
              (cond ((delimiter? nc) (compose-message nc))
                    ((member pc named-char-firsts char=?) 'char-named)
                    (else 'invalid)))
             ((eq? 'char-named pm) (if (delimiter? nc)
                                       (compose-message nc)
                                       'char-named))
             ((eq? 'identifier pm) (if (and (char=? #\| nc)
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
              (cond ((ampersand?          nc) #f)
                    ((backslash?          nc) 'char-init)
                    ((bar?                nc) 'nested-comment)
                    ((char=? #\f          nc) 'false-or-fvector)
                    ((char=? #\t          nc) 'true)
                    ((char-in? '(#\s #\u) nc) 'svector-or-uvector)
                    ((digit10?            nc) 'label-or-reference-or-serial)
                    ((exactness-char?     nc) 'radix-or-digit10)
                    ((exclamation?        nc) 'directive-or-sharp-object)
                    ((lparen?             nc) 'vector)
                    ((radix-char?         nc) (cond ((char=? #\x nc)
                                                     'exactness-or-digit16)
                                                    ((char=? #\d nc)
                                                     'exactness-or-digit10)
                                                    ((char=? #\o nc)
                                                     'exactness-or-digit8)
                                                    ((char=? #\b nc)
                                                     'exactness-or-digit2)
                                                    (else 'invalid)))
                    ((semicolon?          nc) 'datum-comment)
                    (else                     'invalid)))
             ((eq? 'true pm)
              (cond ((and (char=? #\t pc) (delimiter? nc))
                     (compose-message nc))
                    ((and (char=? #\t pc) (char=? #\r nc)) 'true)
                    ((and (char=? #\r pc) (char=? #\u nc)) 'true)
                    ((and (char=? #\u pc) (char=? #\e nc)) 'true)
                    ((delimiter? nc) (compose-message nc))
                    (else 'invalid)))
             (else (compose-message nc)))))))

(define (revise datum revised-kind)
  (call/cc (lambda (done)
             (for-each (lambda (adorned-char)
                         (let ((kind (get-kind adorned-char))
                               (message (get-message adorned-char)))
                           (cond ((eq? 'tbd kind)
                                  (if message
                                      (set-kind! adorned-char revised-kind)
                                      (begin
                                        (set-kind! adorned-char 'default)
                                        (set-message! adorned-char 'revised))))
                                 (else (done revised-kind)))))
                       datum))))

(define (adorn-datum datum)
  (let loop ((adorned '()) (unadorned datum))
    (cond ((null? unadorned) (reverse adorned))
          ((null? adorned) (loop (cons (adorn-char (car unadorned)) adorned)
                                 (cdr unadorned)))
          (else (let ((next (adorn-char (car unadorned))))
                  (set-message! next (compose-message next adorned))
                  (set-kind! next (choose-kind next adorned))
                  (loop (cons next adorned) (cdr unadorned)))))))
