(define (^handle~bind-pm! sym ~sym ident-sym)
  (lambda (ac-list nc pac)
    (cond ((memc nc whitespace-chars) (adorn-char nc 'whitespace ~sym))
          ((char=? nc #\|) (begin-symmetric ac-list nc ident-sym))
          ((memc nc abbrev-chars) (adorn-char nc 'abbrev ~sym))
          ((and (char=? nc #\@) (char=? (get-char pac)) #\,)
           (adorn-char nc 'abbrev ~sym))
          ((memc nc delim-chars) (try-nc! ac-list nc))
          ((and (char=? nc #\#)
                (memq (get-kind pac)
                      (append atmosphere-kinds binding-compounds)))
           (adorn-char nc sym 'binding#))
          (else (adorn-char nc sym sym)))))

(define ^handle~sv-define-pm!
  (^handle~bind-pm! 'sv-define '~sv-define 'sv-define-ident))

(define (handle~sv-define-pm! ac-list nc pac)
  (cond ((memc nc compound-begin-chars) (begin-compound! ac-list nc 'defun))
        (else (^handle~sv-define-pm! ac-list nc pac))))

(define ^handle~named/sv-let-pm!
  (^handle~bind-pm! 'named-let '~named/sv-let 'named-let-ident))

(define (handle~named/sv-let-pm! ac-list nc pac)
  (cond ((memc nc compound-begin-chars)
         (begin-compound! ac-list nc 'let-sv-outer))
        (else (^handle~named/sv-let-pm! ac-list nc pac))))

(define ^handle~~lambda-bind-pm!
  (^handle~bind-pm! 'lambda-rest '~lambda-bind 'lambda-rest-ident))

(define (handle~~lambda-bind-pm! ac-list nc pac)
  (cond ((memc nc compound-begin-chars)
         (begin-compound! ac-list nc 'lambda-bind-list))
        (else (^handle~~lambda-bind-pm! ac-list nc pac))))

(define handle~lambda-bind-pm!
  (^handle~bind-pm! 'lambda-bind '~lambda-bind 'lambda-bind-ident))

(define handle~defun-proc-pm!
  (^handle~bind-pm! 'defun-proc '~defun-proc 'defun-proc-ident))

(define handle~defun-param-pm!
  (^handle~bind-pm! 'defun-param '~defun-param 'defun-param-ident))

(define handle~sv-let-pm! (^handle~bind-pm! 'sv-let '~sv-let 'sv-let-ident))
(define handle~mv-let-pm! (^handle~bind-pm! 'mv-let '~mv-let 'mv-let-ident))

(define ^handle~~mv-define-pm!
  (^handle~bind-pm! 'mv-define-rest '~~mv-define 'mv-define-rest-ident))

(define (handle~~mv-define-pm! ac-list nc pac)
  (cond ((memc nc compound-begin-chars)
         (begin-compound! ac-list nc 'define-mv-list))
        (else (^handle~~mv-define-pm! ac-list nc pac))))

(define handle~mv-define-pm!
  (^handle~bind-pm! 'mv-define '~mv-define 'mv-define-ident))

(define handle~case-lambda-pm!
  (^handle~bind-pm! 'case-lambda-bind '~case-lambda 'case-lambda-bind-ident))

(define handle~defproc-proc-pm!
  (^handle~bind-pm! 'defproc-proc '~defproc-proc 'defproc-proc-ident))

(define (^handle~outer-pm! next-compound-sym mesg)
  (lambda (ac-list nc pac)
    (cond ((memc nc compound-begin-chars)
           (begin-compound! ac-list nc next-compound-sym))
          ((memc nc whitespace-chars) (adorn-char nc 'whitespace mesg))
          ((memc nc abbrev-chars) (adorn-char nc 'abbrev mesg))
          ((and (char=? nc #\@) (char=? (get-char pac)) #\,)
           (adorn-char nc 'abbrev mesg))
          (else (try-nc! ac-list nc)))))

(define handle~~~let-sv-pm! (^handle~outer-pm! 'let-sv-outer '~~~let-sv))
(define handle~~let-sv-pm! (^handle~outer-pm! 'let-sv-inner '~~let-sv))

(define handle~~~~let-mv-pm! (^handle~outer-pm! 'let-mv-outermost '~~~~let-mv))
(define handle~~~let-mv-pm! (^handle~outer-pm! 'let-mv-outer '~~~let-mv))

(define ^handle~~let-mv-pm! (^handle~outer-pm! 'let-mv-inner '~~let-mv))

(define (handle~~let-mv-pm! ac-list nc pac)
  (cond ((char=? nc #\|) (begin-symmetric ac-list nc 'mv-let-rest-ident))
        ((memc nc delim-chars) (^handle~~let-mv-pm! ac-list nc pac))
        ((and (char=? nc #\@) (char=? (get-char pac) #\,))
         (^handle~~let-mv-pm! ac-list nc pac))
        (else (adorn-char nc 'mv-let-rest 'mv-let-rest))))

(define handle~~~case-lambda-pm!
  (^handle~outer-pm! 'case-lambda-outer '~~~case-lambda))
(define handle~~case-lambda-pm!
  (^handle~outer-pm! 'case-lambda-inner '~~case-lambda))

(define handle~defproc-defun-pm!
  (^handle~outer-pm! 'defproc-defun '~defproc-proc))

(define ^handle~defproc-param-pm!
  (^handle~bind-pm! 'defproc-proc '~defproc-proc 'defproc-proc-ident))

(define (handle~defproc-param-pm! ac-list nc pac)
  (cond ((memc nc compound-begin-chars)
         (begin-compound! ac-list nc 'defproc-inner))
        (else (^handle~defproc-param-pm! ac-list nc pac))))
;==============================================================================
(define (^handle:bind-pm! sym ~next-mesg)
  (lambda (ac-list nc pac)
    (cond ((memc nc whitespace-chars)
           (if (char=? (get-char pac) #\.)
               (let ((ppac (cadr ac-list)))
                 (cond ((memq (get-kind ppac) (cons 'abbrev atmosphere-kinds))
                        (set-kind! pac 'dot)
                        (adorn-char nc 'whitespace '~rest-bind))
                       (else (adorn-char nc 'whitespace ~next-mesg))))
               (adorn-char nc 'whitespace ~next-mesg)))
          ((memc nc abbrev-chars) (adorn-char nc 'abbrev ~next-mesg))
          ((memc nc delim-chars) (try-nc! ac-list nc))
          (else (adorn-char nc sym sym)))))

(define handle:sv-define-pm!     (^handle:bind-pm! 'sv-define #f))
(define handle:defun-proc-pm!    (^handle:bind-pm! 'defun-proc '~defun-param))
(define handle:defun-param-pm!   (^handle:bind-pm! 'defun-param '~defun-param))
(define handle:named-let-pm!     (^handle:bind-pm! 'named-let '~~~let-sv))
(define handle:sv-let-pm!        (^handle:bind-pm! 'sv-let #f))
(define handle:lambda-bind-pm!   (^handle:bind-pm! 'lambda-bind '~lambda-bind))
(define handle:lambda-rest-pm!   (^handle:bind-pm! 'lambda-rest #f))
(define handle:mv-let-pm!        (^handle:bind-pm! 'mv-let '~mv-let))
(define handle:mv-let-rest-pm!   (^handle:bind-pm! 'mv-let-rest #f))
(define handle:mv-define-pm!     (^handle:bind-pm! 'mv-define '~mv-define))
(define handle:mv-define-rest-pm! (^handle:bind-pm! 'mv-define-rest #f))
(define handle:case-lambda-bind-pm!
  (^handle:bind-pm! 'case-lambda-bind '~case-lambda))
(define handle:defproc-proc-pm!
  (^handle:bind-pm! 'defproc-proc '~defproc-param))
(define handle:defproc-param-pm!
  (^handle:bind-pm! 'defproc-param '~defproc-param))
(define handle:defproc-spec-pm! (^handle:bind-pm! 'defproc-spec #f))
;==============================================================================
(define (handle:binding#-pm! ac-list nc pac)
  (cond ((char=? nc #\!) (adorn-char nc (get-kind pac) '~dsssl))
        ((memc nc compound-begin-chars)
         (set-mesg! pac 'octothorpe)
         (car (adorn! (list nc) ac-list)))
        (else (let* ((rest (cdr ac-list)) ;; run it back
                     (alternate-pac (car (adorn! '(#\a) rest))))
                (set-mesg! pac (get-mesg alternate-pac))
                (let* ((alternate-ac-list (cons alternate-pac rest))
                       (new-ac (car (adorn! (list nc) alternate-ac-list))))
                  (unless (or (char=? nc #\#) (memc nc delim-chars))
                    (set-kind! new-ac 'invalid))
                  new-ac)))))

(define (handle~dsssl-pm! ac-list nc pac)
  (let ((kind (get-kind pac)))
    (cond ((char=? nc #\k) (adorn-char nc kind '~dsssl/key))
          ((char=? nc #\o) (adorn-char nc kind '~dsssl/opt))
          ((char=? nc #\r) (adorn-char nc kind '~dsssl/rest))
          (else (adorn-char nc 'invalid kind)))))

(define (^handle~dsssl-pm! sym ~sym target)
  (lambda (ac-list nc pac)
    (let ((kind (get-kind pac)) (recents (chars-until ac-list 'binding#)))
      (let ((tested (append recents (list nc))))
        (cond ((matches? target tested)
               (revise-until! ac-list 'dsssl 'binding#)
               (adorn-char nc 'dsssl sym))
              ((could-match? target tested)
               (adorn-char nc kind ~sym))
              (else (adorn-char nc 'invalid kind)))))))

(define handle~dsssl/key-pm!
  (^handle~dsssl-pm! 'dsssl/key '~dsssl/key (string->list "#!key")))
(define handle~dsssl/opt-pm!
  (^handle~dsssl-pm! 'dsssl/opt '~dsssl/opt (string->list "#!optional")))
(define handle~dsssl/rest-pm!
  (^handle~dsssl-pm! 'dsssl/rest '~dsssl/rest (string->list "#!rest")))

(define (^handle~dsssl-key/opt-pm! sym ~sym compound-kind)
  (lambda (ac-list nc pac)
    (cond ((memc nc compound-begin-chars)
           (begin-compound! ac-list nc compound-kind))
          ((memc nc whitespace-chars) (adorn-char nc 'whitespace ~sym))
          ((memc nc abbrev-chars) (adorn-char nc 'abbrev ~sym))
          ((and (char=? nc #\@) (char=? (get-char pac)) #\,)
           (adorn-char nc 'abbrev ~sym))
          ((memc nc delim-chars) (try-nc! ac-list nc))
          ((char=? nc #\#) (adorn-char nc sym 'binding#))
          (else (adorn-char nc sym sym)))))

(define handle~~key-bind-pm!
  (^handle~dsssl-key/opt-pm! 'key-bind '~~key-bind 'compound-key))
(define handle~~opt-bind-pm!
  (^handle~dsssl-key/opt-pm! 'opt-bind '~~opt-bind 'compound-opt))

(define handle~rest-bind-pm!
  (^handle~bind-pm! 'rest-bind '~rest-bind 'rest-bind-ident))

(define (handle:dsssl/key-pm! ac-list nc pac)
  (cond ((memc nc delim-chars) (handle~~key-bind-pm! ac-list nc pac))
        (else (adorn-char nc 'invalid '~~key-bind))))

(define (handle:dsssl/opt-pm! ac-list nc pac)
  (cond ((memc nc delim-chars) (handle~~opt-bind-pm! ac-list nc pac))
        (else (adorn-char nc 'invalid '~~opt-bind))))

(define (handle:dsssl/rest-pm! ac-list nc pac)
  (cond ((memc nc delim-chars) (handle~rest-bind-pm! ac-list nc pac))
        (else (adorn-char nc 'invalid '~rest-bind))))

(define handle:key-bind-pm! (^handle:bind-pm! 'key-bind '~~key-bind))
(define handle:opt-bind-pm! (^handle:bind-pm! 'opt-bind '~~opt-bind))
(define handle:rest-bind-pm! (^handle:bind-pm! 'rest-bind '~rest-bind))

(define handle:key-init-pm! (^handle:bind-pm! 'key-bind #f))
(define handle:opt-init-pm! (^handle:bind-pm! 'opt-bind #f))
(define handle:key-init-pm! (^handle:bind-pm! 'key-init #f))
(define handle:opt-init-pm! (^handle:bind-pm! 'opt-init #f))

(define handle~key-pm! (^handle~bind-pm! 'key-init '~key-init 'key-init-ident))
(define handle~opt-pm! (^handle~bind-pm! 'opt-init '~opt-init 'opt-init-ident))
;==============================================================================
(define (try-bind-pm! ac-list nc pac pm)
  (cond ((eq? pm 'binding#)         (handle:binding#-pm! ac-list nc pac))
        ((eq? pm 'sv-define)        (handle:sv-define-pm! ac-list nc pac))
        ((eq? pm 'lambda-bind)      (handle:lambda-bind-pm! ac-list nc pac))
        ((eq? pm 'lambda-rest)      (handle:lambda-rest-pm! ac-list nc pac))
        ((eq? pm 'sv-let)           (handle:sv-let-pm! ac-list nc pac))
        ((eq? pm 'named-let)        (handle:named-let-pm! ac-list nc pac))
        ((eq? pm 'defun-proc)       (handle:defun-proc-pm! ac-list nc pac))
        ((eq? pm 'defun-param)      (handle:defun-param-pm! ac-list nc pac))
        ((eq? pm 'mv-let)           (handle:mv-let-pm! ac-list nc pac))
        ((eq? pm 'mv-let-rest)      (handle:mv-let-rest-pm! ac-list nc pac))
        ((eq? pm 'mv-define)        (handle:mv-define-pm! ac-list nc pac))
        ((eq? pm 'mv-define-rest)   (handle:mv-define-rest-pm! ac-list nc pac))
        ((eq? pm 'defproc-proc)     (handle:defproc-proc-pm! ac-list nc pac))
        ((eq? pm 'key-bind)         (handle:key-bind-pm! ac-list nc pac))
        ((eq? pm 'opt-bind)         (handle:opt-bind-pm! ac-list nc pac))
        ((eq? pm 'rest-bind)        (handle:rest-bind-pm! ac-list nc pac))
        ((eq? pm 'key-init)         (handle:key-init-pm! ac-list nc pac))
        ((eq? pm 'opt-init)         (handle:opt-init-pm! ac-list nc pac))
        ((eq? pm '~dsssl)           (handle~dsssl-pm! ac-list nc pac))
        ((eq? pm '~dsssl/key)       (handle~dsssl/key-pm! ac-list nc pac))
        ((eq? pm '~dsssl/opt)       (handle~dsssl/opt-pm! ac-list nc pac))
        ((eq? pm '~dsssl/rest)      (handle~dsssl/rest-pm! ac-list nc pac))
        ((eq? pm 'dsssl/key)        (handle:dsssl/key-pm! ac-list nc pac))
        ((eq? pm 'dsssl/opt)        (handle:dsssl/opt-pm! ac-list nc pac))
        ((eq? pm 'dsssl/rest)       (handle:dsssl/rest-pm! ac-list nc pac))
        ((eq? pm '~rest-bind)       (handle~rest-bind-pm! ac-list nc pac))
        ((eq? pm '~~lambda-bind)    (handle~~lambda-bind-pm! ac-list nc pac))
        ((eq? pm '~sv-define)       (handle~sv-define-pm! ac-list nc pac))
        ((eq? pm '~named/sv-let)    (handle~named/sv-let-pm! ac-list nc pac))
        ((eq? pm '~~~~let-mv)       (handle~~~~let-mv-pm! ac-list nc pac))
        ((eq? pm '~defproc-defun)   (handle~defproc-defun-pm! ac-list nc pac))
        ((eq? pm 'case-lambda-bind)
         (handle:case-lambda-bind-pm! ac-list nc pac))
        ((memq pm '(~defun-param defun-proc-ident-end defun-param-ident-end))
         (handle~defun-param-pm! ac-list nc pac))
        ((memq pm '(~~~let-sv named-let-ident-end))
         (handle~~~let-sv-pm! ac-list nc pac))
        ((memq pm '(~~mv-define mv-define-ident-end))
         (handle~~mv-define-pm! ac-list nc pac))
        ((memq pm '(~key subcompound-key-unmatched))
         (handle~key-pm! ac-list nc pac))
        ((memq pm '(~opt subcompound-opt-unmatched))
         (handle~opt-pm! ac-list nc pac))
        ((memq pm '(~~key-bind subcompound-key-end))
         (handle~~key-bind-pm! ac-list nc pac))
        ((memq pm '(~~opt-bind subcompound-opt-end))
         (handle~~opt-bind-pm! ac-list nc pac))
        ((memq pm '(~lambda-bind lambda-bind-ident-end
                                 sublambda-bind-list-unmatched))
         (handle~lambda-bind-pm! ac-list nc pac))
        ((memq pm '(~defun-proc subdefun-unmatched))
         (handle~defun-proc-pm! ac-list nc pac))
        ((memq pm '(~sv-let sublet-sv-inner-unmatched))
         (handle~sv-let-pm! ac-list nc pac))
        ((memq pm '(~~let-sv sublet-sv-outer-unmatched sublet-sv-inner-end))
         (handle~~let-sv-pm! ac-list nc pac))
        ((memq pm '(~mv-let mv-let-ident-end sublet-mv-inner-unmatched))
         (handle~mv-let-pm! ac-list nc pac))
        ((memq pm '(~~let-mv sublet-mv-outer-unmatched))
         (handle~~let-mv-pm! ac-list nc pac))
        ((memq pm '(~~~let-mv sublet-mv-outermost-unmatched
                              sublet-mv-outer-end))
         (handle~~~let-mv-pm! ac-list nc pac))
        ((memq pm '(~mv-define subdefine-mv-list-unmatched))
         (handle~mv-define-pm! ac-list nc pac))
        ((memq pm '(~mv-define subdefine-mv-list-unmatched))
         (handle~mv-define-pm! ac-list nc pac))
        ((memq pm '(~case-lambda case-lambda-bind-ident-end
                                 subcase-lambda-inner-unmatched))
         (handle~case-lambda-pm! ac-list nc pac))
        ((memq pm '(~~case-lambda subcase-lambda-outer-unmatched))
         (handle~~case-lambda-pm! ac-list nc pac))
        ((memq pm '(~~~case-lambda subcase-lambda-outer-end))
         (handle~~~case-lambda-pm! ac-list nc pac))
        ((memq pm '(~defproc-proc subdefproc-defun-unmatched))
         (handle~defproc-proc-pm! ac-list nc pac))
        (else #f)))
