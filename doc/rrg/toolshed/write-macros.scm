#!/usr/bin/env gsi-script

(define syntax-classes
  '(abbrev
    atmosphere
    boolean
    box
    char
    char-body
    compound
    compound-empty
    datum-label
    datum-ref
    def-like-bind
    def-like-esc
    dot
    dsssl
    hs-begin
    hs-key
    ident
    ident-esc
    invalid
    key-bind
    key-init
    keyword
    let-like-bind
    let-like-esc
    number
    repl-ref
    serial-ref
    sharp
    shebang
    string
    string-esc
    syntax
    syntax-esc))

    ;; ok
    ;; problem

(define kind->macro-name
  (let ((rev-string->list (lambda (str) (reverse (string->list str)))))
    (lambda (kind)
      (let loop ((old (string->list (symbol->string kind))) (new '()))
        (if (null? old)
            (reverse new)
            (let ((next (car old)))
              (cond
               ((char=? next #\-)
                (loop (cdr old) (append (rev-string->list "MINUS") new)))
               ((char=? next #\+)
                (loop (cdr old) (append (rev-string->list "PLUS") new)))
               ((char=? next #\/)
                (loop (cdr old) (append (rev-string->list "SLASH") new)))
               ((char=? next #\~)
                (loop (cdr old) (append (rev-string->list "TILDE") new)))
               ((char=? next #\#)
                (loop (cdr old) (append (rev-string->list "OCTOTHORPE") new)))
               ((char=? next #\0)
                (loop (cdr old) (append (rev-string->list "ZERO") new)))
               ((char=? next #\1)
                (loop (cdr old) (append (rev-string->list "ONE") new)))
               ((char=? next #\2)
                (loop (cdr old) (append (rev-string->list "TWO") new)))
               ((char=? next #\3)
                (loop (cdr old) (append (rev-string->list "THREE") new)))
               ((char=? next #\4)
                (loop (cdr old) (append (rev-string->list "FOUR") new)))
               ((char=? next #\5)
                (loop (cdr old) (append (rev-string->list "FIVE") new)))
               ((char=? next #\6)
                (loop (cdr old) (append (rev-string->list "SIX") new)))
               ((char=? next #\7)
                (loop (cdr old) (append (rev-string->list "SEVEN") new)))
               ((char=? next #\8)
                (loop (cdr old) (append (rev-string->list "EIGHT") new)))
               ((char=? next #\9)
                (loop (cdr old) (append (rev-string->list "NINE") new)))
               (else (loop (cdr old) (cons next new))))))))))

(define (write-lisp-syntax-macro kind)
  (write-string
   (string-append "@macro "
                  (list->string (kind->macro-name kind))
                  " {xx}\n"
                  "@inlinefmtifelse{html,@inlineraw{html,<span class=\""
                  (symbol->string kind)
                  "\">\\xx\\</span>},\\xx\\}\n"
                  "@end macro\n")))
