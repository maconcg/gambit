(define (^handle~bind! sym ~sym ident-sym)
  (let ((beginning-kinds (append atmosphere-kinds binding-compounds)))
    (lambda (ac-list nc pac)
      (cond ((memc nc whitespace-chars) (adorn-char nc 'whitespace ~sym))
            ((char=? nc #\|) (begin-symmetric ac-list nc ident-sym))
            ((memc nc abbrev-chars) (adorn-char nc 'abbrev ~sym))
            ((and (char=? nc #\@) (char=? (get-char pac)) #\,)
             (adorn-char nc 'abbrev ~sym))
            ((memc nc delim-chars) (try-nc! ac-list nc))
            ((and (char=? nc #\#) (memq (get-kind pac) beginning-kinds))
             (adorn-char nc sym 'binding#))
            (else (adorn-char nc sym sym))))))

(define ^handle~sv-define!
  (^handle~bind! 'sv-define '~sv-define 'sv-define-ident))

(define (handle~sv-define! ac-list nc pac)
  (cond ((memc nc compound-begin-chars) (begin-compound! ac-list nc 'defun))
        (else (^handle~sv-define! ac-list nc pac))))

(define ^handle~named/sv-let!
  (^handle~bind! 'named-let '~named/sv-let 'named-let-ident))

(define (handle~named/sv-let! ac-list nc pac)
  (cond ((memc nc compound-begin-chars)
         (begin-compound! ac-list nc 'let-sv-outer))
        (else (^handle~named/sv-let! ac-list nc pac))))

(define ^handle~~lambda-bind!
  (^handle~bind! 'lambda-rest '~lambda-bind 'lambda-rest-ident))

(define (handle~~lambda-bind! ac-list nc pac)
  (cond ((memc nc compound-begin-chars)
         (begin-compound! ac-list nc 'lambda-bind-list))
        (else (^handle~~lambda-bind! ac-list nc pac))))

(define handle~lambda-bind!
  (^handle~bind! 'lambda-bind '~lambda-bind 'lambda-bind-ident))

(define handle~defun-proc!
  (^handle~bind! 'defun-proc '~defun-proc 'defun-proc-ident))

(define handle~defun-param!
  (^handle~bind! 'defun-param '~defun-param 'defun-param-ident))

(define handle~defproc-proc!
  (^handle~bind! 'defproc-proc '~defproc-proc 'defproc-proc-ident))

(define ^handle~defproc-param!
  (^handle~bind! 'defproc-param '~defproc-param 'defproc-param-ident))

(define (handle~defproc-param! ac-list nc pac)
  (cond ((memc nc compound-begin-chars)
         (begin-compound! ac-list nc 'defproc-inner))
        (else (^handle~defproc-param! ac-list nc pac))))

(define handle~defproc-spec!
  (^handle~bind! 'defproc-spec '~defproc-spec 'defproc-spec-ident))

(define handle~sv-let! (^handle~bind! 'sv-let '~sv-let 'sv-let-ident))
(define handle~mv-let! (^handle~bind! 'mv-let '~mv-let 'mv-let-ident))

(define ^handle~~mv-define!
  (^handle~bind! 'mv-define-rest '~~mv-define 'mv-define-rest-ident))

(define (handle~~mv-define! ac-list nc pac)
  (cond ((memc nc compound-begin-chars)
         (begin-compound! ac-list nc 'define-mv-list))
        (else (^handle~~mv-define! ac-list nc pac))))

(define handle~mv-define!
  (^handle~bind! 'mv-define '~mv-define 'mv-define-ident))

(define handle~case-lambda!
  (^handle~bind! 'case-lambda-bind '~case-lambda 'case-lambda-bind-ident))

(define (^handle~outer! next-compound-sym mesg)
  (lambda (ac-list nc pac)
    (cond ((memc nc compound-begin-chars)
           (begin-compound! ac-list nc next-compound-sym))
          ((memc nc whitespace-chars) (adorn-char nc 'whitespace mesg))
          ((memc nc abbrev-chars) (adorn-char nc 'abbrev mesg))
          ((and (char=? nc #\@) (char=? (get-char pac)) #\,)
           (adorn-char nc 'abbrev mesg))
          (else (try-nc! ac-list nc)))))

(define handle~~~let-sv! (^handle~outer! 'let-sv-outer '~~~let-sv))
(define handle~~let-sv! (^handle~outer! 'let-sv-inner '~~let-sv))

(define handle~~~~let-mv! (^handle~outer! 'let-mv-outermost '~~~~let-mv))
(define handle~~~let-mv! (^handle~outer! 'let-mv-outer '~~~let-mv))

(define ^handle~~let-mv! (^handle~outer! 'let-mv-inner '~~let-mv))

(define (handle~~let-mv! ac-list nc pac)
  (cond ((char=? nc #\|) (begin-symmetric ac-list nc 'mv-let-rest-ident))
        ((memc nc delim-chars) (^handle~~let-mv! ac-list nc pac))
        ((and (char=? nc #\@) (char=? (get-char pac) #\,))
         (^handle~~let-mv! ac-list nc pac))
        (else (adorn-char nc 'mv-let-rest 'mv-let-rest))))

(define handle~~~case-lambda!
  (^handle~outer! 'case-lambda-outer '~~~case-lambda))
(define handle~~case-lambda!
  (^handle~outer! 'case-lambda-inner '~~case-lambda))

(define handle~~defproc! (^handle~outer! 'defproc '~~defproc))
;==============================================================================
(define (^handle:bind! sym ~next-mesg)
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

(define handle:sv-define!     (^handle:bind! 'sv-define #f))
(define handle:defun-proc!    (^handle:bind! 'defun-proc '~defun-param))
(define handle:defun-param!   (^handle:bind! 'defun-param '~defun-param))
(define handle:named-let!     (^handle:bind! 'named-let '~~~let-sv))
(define handle:sv-let!        (^handle:bind! 'sv-let #f))
(define handle:lambda-bind!   (^handle:bind! 'lambda-bind '~lambda-bind))
(define handle:lambda-rest!   (^handle:bind! 'lambda-rest #f))
(define handle:mv-let!        (^handle:bind! 'mv-let '~mv-let))
(define handle:mv-let-rest!   (^handle:bind! 'mv-let-rest #f))
(define handle:mv-define!     (^handle:bind! 'mv-define '~mv-define))
(define handle:mv-define-rest! (^handle:bind! 'mv-define-rest #f))
(define handle:case-lambda-bind!
  (^handle:bind! 'case-lambda-bind '~case-lambda))
(define handle:defproc-proc!
  (^handle:bind! 'defproc-proc '~defproc-param))
(define handle:defproc-param!
  (^handle:bind! 'defproc-param '~defproc-param))
(define handle:defproc-spec! (^handle:bind! 'defproc-spec #f))
;==============================================================================
(define (handle:binding#! ac-list nc pac)
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

(define (handle~dsssl! ac-list nc pac)
  (let ((kind (get-kind pac)))
    (cond ((char=? nc #\k) (adorn-char nc kind '~dsssl/key))
          ((char=? nc #\o) (adorn-char nc kind '~dsssl/opt))
          ((char=? nc #\r) (adorn-char nc kind '~dsssl/rest))
          (else (adorn-char nc 'invalid kind)))))

(define (^handle~dsssl! sym ~sym target)
  (lambda (ac-list nc pac)
    (let ((kind (get-kind pac)) (recents (chars-until ac-list 'binding#)))
      (let ((tested (append recents (list nc))))
        (cond ((matches? target tested)
               (revise-until! ac-list 'dsssl 'binding#)
               (adorn-char nc 'dsssl sym))
              ((could-match? target tested)
               (adorn-char nc kind ~sym))
              (else (adorn-char nc 'invalid kind)))))))

(define handle~dsssl/key!
  (^handle~dsssl! 'dsssl/key '~dsssl/key (string->list "#!key")))
(define handle~dsssl/opt!
  (^handle~dsssl! 'dsssl/opt '~dsssl/opt (string->list "#!optional")))
(define handle~dsssl/rest!
  (^handle~dsssl! 'dsssl/rest '~dsssl/rest (string->list "#!rest")))

(define (^handle~dsssl-key/opt! sym ~sym compound-kind)
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

(define handle~~key-bind!
  (^handle~dsssl-key/opt! 'key-bind '~~key-bind 'compound-key))
(define handle~~opt-bind!
  (^handle~dsssl-key/opt! 'opt-bind '~~opt-bind 'compound-opt))

(define handle~rest-bind!
  (^handle~bind! 'rest-bind '~rest-bind 'rest-bind-ident))

(define (handle:dsssl/key! ac-list nc pac)
  (cond ((memc nc delim-chars) (handle~~key-bind! ac-list nc pac))
        (else (adorn-char nc 'invalid '~~key-bind))))

(define (handle:dsssl/opt! ac-list nc pac)
  (cond ((memc nc delim-chars) (handle~~opt-bind! ac-list nc pac))
        (else (adorn-char nc 'invalid '~~opt-bind))))

(define (handle:dsssl/rest! ac-list nc pac)
  (cond ((memc nc delim-chars) (handle~rest-bind! ac-list nc pac))
        (else (adorn-char nc 'invalid '~rest-bind))))

(define handle:key-bind! (^handle:bind! 'key-bind '~~key-bind))
(define handle:opt-bind! (^handle:bind! 'opt-bind '~~opt-bind))
(define handle:rest-bind! (^handle:bind! 'rest-bind '~rest-bind))

(define handle:key-init! (^handle:bind! 'key-bind #f))
(define handle:opt-init! (^handle:bind! 'opt-bind #f))
(define handle:key-init! (^handle:bind! 'key-init #f))
(define handle:opt-init! (^handle:bind! 'opt-init #f))

(define handle~key! (^handle~bind! 'key-init '~key-init 'key-init-ident))
(define handle~opt! (^handle~bind! 'opt-init '~opt-init 'opt-init-ident))
;==============================================================================
(define (try-bind-pm! ac-list nc pac pm)
  (let ((defun-proc~   '( ~defun-proc subdefun-unmatched ))
        (sv-let-outer~ '( ~~~let-sv named-let-ident-end ))
        (sv-let~       '( ~sv-let sublet-sv-inner-unmatched ))
        (mv-let-inner~ '( ~~let-mv sublet-mv-outer-unmatched ))
        (mv-let~       '( ~mv-let mv-let-ident-end sublet-mv-inner-unmatched ))
        (case-lambda-outermost~ '( ~~~case-lambda subcase-lambda-outer-end ))
        (case-lambda-outer~ '( ~~case-lambda subcase-lambda-outer-unmatched ))
        (key-init~          '( ~key subcompound-key-unmatched ))
        (opt-init~          '( ~opt subcompound-opt-unmatched ))
        (key-bind~          '( ~~key-bind subcompound-key-end ))
        (opt-bind~          '( ~~opt-bind subcompound-opt-end ))
        (defproc-proc~      '( ~defproc-proc subdefproc-unmatched ))
        (defun-param~       '( ~defun-param defun-proc-ident-end
                               defun-param-ident-end ))
        (lambda-bind~       '( ~lambda-bind lambda-bind-ident-end
                               sublambda-bind-list-unmatched ))
        (sv-let-inner~      '( ~~let-sv sublet-sv-outer-unmatched
                               sublet-sv-inner-end ))
        (mv-let-outer~      '( ~~~let-mv sublet-mv-outermost-unmatched
                               sublet-mv-outer-end ))
        (mv-define~         '( ~mv-define mv-define-ident-end
                               subdefine-mv-list-unmatched ))
        (case-lambda-bind~  '( ~case-lambda case-lambda-bind-ident-end
                               subcase-lambda-inner-unmatched ))
        (defproc-param~     '( ~defproc-param defproc-proc-ident-end
                               defproc-param-ident-end subdefproc-inner-end ))
        (defproc-spec~      '( ~defproc-spec subdefproc-inner-unmatched )))
    (cond
     ((eq? pm 'sv-define)            (handle:sv-define!        ac-list nc pac))
     ((eq? pm 'lambda-bind)          (handle:lambda-bind!      ac-list nc pac))
     ((eq? pm 'lambda-rest)          (handle:lambda-rest!      ac-list nc pac))
     ((eq? pm 'sv-let)               (handle:sv-let!           ac-list nc pac))
     ((eq? pm 'named-let)            (handle:named-let!        ac-list nc pac))
     ((eq? pm 'defun-proc)           (handle:defun-proc!       ac-list nc pac))
     ((eq? pm 'defun-param)          (handle:defun-param!      ac-list nc pac))
     ((eq? pm 'mv-let)               (handle:mv-let!           ac-list nc pac))
     ((eq? pm 'mv-let-rest)          (handle:mv-let-rest!      ac-list nc pac))
     ((eq? pm 'mv-define)            (handle:mv-define!        ac-list nc pac))
     ((eq? pm 'mv-define-rest)       (handle:mv-define-rest!   ac-list nc pac))
     ((eq? pm 'case-lambda-bind)     (handle:case-lambda-bind! ac-list nc pac))
     ((eq? pm 'defproc-param)        (handle:defproc-param!    ac-list nc pac))
     ((eq? pm 'defproc-proc)         (handle:defproc-proc!     ac-list nc pac))
     ((eq? pm 'defproc-spec)         (handle:defproc-spec!     ac-list nc pac))
     ((eq? pm 'binding#)             (handle:binding#!         ac-list nc pac))
     ((eq? pm 'key-bind)             (handle:key-bind!         ac-list nc pac))
     ((eq? pm 'opt-bind)             (handle:opt-bind!         ac-list nc pac))
     ((eq? pm 'rest-bind)            (handle:rest-bind!        ac-list nc pac))
     ((eq? pm 'key-init)             (handle:key-init!         ac-list nc pac))
     ((eq? pm 'opt-init)             (handle:opt-init!         ac-list nc pac))
     ((eq? pm 'dsssl/key)            (handle:dsssl/key!        ac-list nc pac))
     ((eq? pm 'dsssl/opt)            (handle:dsssl/opt!        ac-list nc pac))
     ((eq? pm 'dsssl/rest)           (handle:dsssl/rest!       ac-list nc pac))
     ((eq? pm '~dsssl)               (handle~dsssl!            ac-list nc pac))
     ((eq? pm '~dsssl/key)           (handle~dsssl/key!        ac-list nc pac))
     ((eq? pm '~dsssl/opt)           (handle~dsssl/opt!        ac-list nc pac))
     ((eq? pm '~dsssl/rest)          (handle~dsssl/rest!       ac-list nc pac))
     ((eq? pm '~rest-bind)           (handle~rest-bind!        ac-list nc pac))
     ((eq? pm '~~lambda-bind)        (handle~~lambda-bind!     ac-list nc pac))
     ((eq? pm '~sv-define)           (handle~sv-define!        ac-list nc pac))
     ((eq? pm '~named/sv-let)        (handle~named/sv-let!     ac-list nc pac))
     ((eq? pm '~~~~let-mv)           (handle~~~~let-mv!        ac-list nc pac))
     ((eq? pm '~~defproc)            (handle~~defproc!         ac-list nc pac))
     ((memq pm defun-param~)           (handle~defun-param!    ac-list nc pac))
     ((memq pm sv-let-outer~)          (handle~~~let-sv!       ac-list nc pac))
     ((memq pm sv-let-inner~)          (handle~~let-sv!        ac-list nc pac))
     ((memq pm sv-let~)                (handle~sv-let!         ac-list nc pac))
     ((memq pm mv-define~)             (handle~~mv-define!     ac-list nc pac))
     ((memq pm key-init~)              (handle~key!            ac-list nc pac))
     ((memq pm opt-init~)              (handle~opt!            ac-list nc pac))
     ((memq pm key-bind~)              (handle~~key-bind!      ac-list nc pac))
     ((memq pm opt-bind~)              (handle~~opt-bind!      ac-list nc pac))
     ((memq pm lambda-bind~)           (handle~lambda-bind!    ac-list nc pac))
     ((memq pm defun-proc~)            (handle~defun-proc!     ac-list nc pac))
     ((memq pm mv-let-outer~)          (handle~~~let-mv!       ac-list nc pac))
     ((memq pm mv-let-inner~)          (handle~~let-mv!        ac-list nc pac))
     ((memq pm mv-let~)                (handle~mv-let!         ac-list nc pac))
     ((memq pm mv-define~)             (handle~mv-define!      ac-list nc pac))
     ((memq pm case-lambda-bind~)      (handle~case-lambda!    ac-list nc pac))
     ((memq pm case-lambda-outer~)     (handle~~case-lambda!   ac-list nc pac))
     ((memq pm case-lambda-outermost~) (handle~~case-lambda!   ac-list nc pac))
     ((memq pm defproc-proc~)          (handle~defproc-proc!   ac-list nc pac))
     ((memq pm defproc-param~)         (handle~defproc-param!  ac-list nc pac))
     ((memq pm defproc-spec~)          (handle~defproc-spec!   ac-list nc pac))
     (else #f))))
