#!/usr/bin/env gsi-script

(load "adorn/adorn")
(load "write-macros.scm")

(define (file->char-list file)
  (call-with-input-file file
    (lambda (p) (read-all p read-char))))

(define (main . args)
  (let* ((txi (car args)) (char-list (file->char-list txi)))
    (display/watch-for-lisp char-list)))

(define lisp-begin (string->list "\n@lisp\n"))
(define lisp-end (string->list "\n@end lisp\n"))
(define lisp-end-length (length lisp-end))

(define (display/watch-for-lisp chars)
  (let ((initial-buffer (if (and (not (null? chars)) (char=? (car chars) #\@))
                            '(#\newline)
                            '())))
    (let loop ((rest chars) (buffer initial-buffer))
      (unless (null? rest)
        (let ((nc (car rest)))
          (cond ((null? buffer)
                 (display nc)
                 (loop (cdr rest) (if (char=? nc #\newline)
                                      (cons nc buffer)
                                      '())))
                ((adorn#matches? lisp-begin (reverse buffer))
                 (let ((lisp/rest (collect-lisp/rest rest)))
                   (write-lisp+macro-defs (reverse (car lisp/rest)))
                   (display/watch-for-lisp (cadr lisp/rest))))
                ((adorn#could-match? lisp-begin (reverse buffer))
                 (display nc)
                 (loop (cdr rest) (cons nc buffer)))
                (else (display nc)
                      (loop (cdr rest) '()))))))))

(define (collect-lisp/rest char-list)
  (let ((initial-buffer (if (char=? (car char-list) #\@) '(#\newline) '())))
    (let loop ((lisp '()) (rest char-list) (buffer initial-buffer))
      (if (null? rest)
          (list lisp '())
          (let ((nc (car rest)))
            (cond ((null? buffer)
                   (loop (cons nc lisp) (cdr rest) (if (char=? nc #\newline)
                                                       (cons nc buffer)
                                                       '())))
                  ((adorn#matches? lisp-end (reverse buffer))
                   (list (list-tail lisp lisp-end-length)
                         (append lisp-end rest)))
                  ((adorn#could-match? lisp-end (reverse buffer))
                   (loop (cons nc lisp) (cdr rest) (cons nc buffer)))
                  (else (loop (cons nc lisp) (cdr rest) '()))))))))

(define (basename path-string)
  (let loop ((new '()) (old (reverse (string->list path-string))))
    (if (null? old)
        (list->string new)
        (let ((next (car old)))
          (if (char=? next #\/)
              (list->string new)
              (loop (cons next new) (cdr old)))))))

(define (whitespace-char? c) (member c '(#\space #\newline #\tab) char=?))

(define (strip-leading-whitespace char-list)
  (cond ((null? char-list) char-list)
        ((whitespace-char? (car char-list)) (strip-whitespace (cdr char-list)))
        (else char-list)))

(define (strip-trailing-whitespace char-list)
  (reverse (strip-leading-whitespace (reverse char-list))))

(define (strip-whitespace char-list)
  (strip-leading-whitespace (strip-trailing-whitespace char-list)))

(define expression/expectation/trailer
  (let ((tail-matches?
         (lambda (goal)
           (let ((goal-length (string-length goal))
                 (goal-exploded (string->list goal)))
             (lambda (actual)
               (let ((actual-length (length actual)))
                 (and (>= actual-length goal-length)
                      (let* ((tail-length (- actual-length goal-length))
                             (tail (list-tail actual tail-length)))
                        (adorn#matches? goal-exploded tail)))))))))
    (let ((list-head (lambda (l n) (reverse (list-tail (reverse l) n))))
          (exception-macro? (tail-matches? "@exception{"))
          (exception-length (string-length "@exception{"))
          (ok-macro? (tail-matches? "@ok{"))
          (ok-length (string-length "@ok{"))
          (problem-macro? (tail-matches? "@problem{"))
          (problem-length (string-length "@problem{")))
      (let ((get-expression
             (lambda (char-list length)
               (strip-trailing-whitespace (list-head char-list length))))
            (get-expectation
             (lambda (char-list)
               (let loop ((rest char-list) (expectation '()))
                 (cond ((null? rest) expectation)
                       (else (let ((next (car rest)))
                               (cond ((char=? next #\}) ; use @backslashchar{}
                                      (reverse (cons #\} expectation)))
                                     (else (loop (cdr rest)
                                                 (cons next
                                                       expectation))))))))))
            (get-trailer
             (lambda (char-list)
               (let loop ((rest char-list) (trailer '()))
                 (cond ((null? rest) trailer)
                       (else (let ((next (car rest)))
                               (cond ((whitespace-char? next)
                                      (loop (cdr rest) (cons next trailer)))
                                     (else (reverse trailer))))))))))
        (let ((get-e/e/t
               (lambda (char-list chars e+e macro-length)
                 (let* ((expression (get-expression e+e macro-length))
                        (expr-len (length expression))
                        (expectation (get-expectation (list-tail char-list
                                                                 expr-len)))
                        (expect-len (length expectation))
                        (trailer (get-trailer (list-tail char-list
                                                         (+ expr-len
                                                            expect-len)))))
                   (list expression expectation trailer)))))
          (lambda (char-list)
            (let loop ((chars char-list) (e+e '()))
              (cond ((null? chars)
                     (list char-list '() '()))
                    ((ok-macro? e+e)
                     (get-e/e/t char-list chars e+e ok-length))
                    ((exception-macro? e+e)
                     (get-e/e/t char-list chars e+e exception-length))
                    ((problem-macro? e+e)
                     (get-e/e/t char-list chars e+e problem-length))
                    (else (loop (cdr chars)
                                (append e+e (list (car chars)))))))))))))

(define char->texi-char
  (let ((texinfo-safe (append '(#\space #\newline)
                              (char-set->list
                               (char-set-intersection char-set:letter+digit
                                                      char-set:ascii)))))
    (letrec ((zero-pad (lambda (char-list)
                         (if (> 4 (length char-list))
                             (zero-pad (cons #\0 char-list))
                             char-list))))
      (let ((char->texinfo-maybe-U
             (lambda (char)
               (if (member char texinfo-safe char=?)
                   (list char)
                   (append '(#\@ #\U #\{)
                           (zero-pad
                            (map char-upcase
                                 (string->list
                                  (number->string (char->integer char)))))
                           '(#\}))))))
        (lambda (char)
          (cond ((char=? char #\&) (string->list "@ampchar{}"))
                ((char=? char #\@) (string->list "@atchar{}"))
                ((char=? char #\\) (string->list "@backslashchar{}"))
                ((char=? char #\,) (string->list "@comma{}"))
                ((char=? char #\#) (string->list "@hashchar{}"))
                ((char=? char #\{) (string->list "@lbracechar{}"))
                ((char=? char #\}) (string->list "@rbracechar{}"))
                (else (char->texinfo-maybe-U char))))))))

(define (adorn+simplify char-list)
  (adorn#reverse+simplify-kinds! (adorn#adorn! char-list)))

(define (kind->macro-open kind)
  (append '(#\@) (kind->macro-name kind) '(#\{)))

;; (define (unique-kinds ac-list)
;;   (let loop ((rest ac-list) (kinds '()))
;;     (if (null? rest)
;;         kinds
;;         (let 

;; (define (write-macro-defs ac-list)
  ;; (write-string (string-append "<span class=\""
  ;;                              (symbol->string kind)
  ;;                              "\">"))))

(define (write-lisp+macro-defs char-list)
  (unless (null? char-list)
    (let ((e/e/t (expression/expectation/trailer char-list)))
      (let ((expression (car e/e/t))
            (expectation (cadr e/e/t))
            (trailer (caddr e/e/t)))
        (let ((adorned+simplified-expression (adorn+simplify expression))
              (total-length (length (append expression expectation trailer))))
          ;; (write-macro-defs adorned+simplified-expression)
          (write-ac-list adorned+simplified-expression)
          (for-each write-char (append expectation trailer))
          (write-lisp+macro-defs (list-tail char-list total-length)))))))


(define (write-chars char-list) (for-each write-char char-list))

(define write-ac-list
  (let ((open-macro (lambda (kind) (write-chars (kind->macro-open kind))))
        (close-macro (lambda () (write-char #\}))))
    (lambda (ac-list)
      (let loop ((rest ac-list) (macro #f))
        (cond ((null? rest) (when macro (close-macro)))
              (else (let ((ac (car rest)))
                      (let ((c (adorn#get-char ac)) (k (adorn#get-kind ac)))
                        (cond ((not macro)
                               (cond ((memq k '(default whitespace))
                                      (write-chars (char->texi-char c))
                                      (loop (cdr rest) #f))
                                     (else
                                      (open-macro k)
                                      (write-chars (char->texi-char c))
                                      (loop (cdr rest) k))))
                              (else (cond ((memq k (list macro 'whitespace))
                                           (write-chars (char->texi-char c))
                                           (loop (cdr rest) macro))
                                          ((eq? k 'default)
                                           (close-macro)
                                           (write-chars (char->texi-char c))
                                           (loop (cdr rest) #f))
                                          (else (close-macro)
                                                (open-macro k)
                                                (write-chars
                                                 (char->texi-char c))
                                                (loop (cdr rest) k)))))))))))))
