(define (string-esc? ac) (eq? (get-kind ac) 'string-esc))
(define (ident-esc? ac) (eq? (get-kind ac) 'ident-esc))
(define (sv-define-ident-esc? ac) (eq? (get-kind ac) 'sv-define-ident-esc))
(define (defun-param-ident-esc? ac) (eq? (get-kind ac) 'defun-param-ident-esc))
(define (defun-proc-ident-esc? ac) (eq? (get-kind ac) 'defun-proc-ident-esc))
(define (sv-let-ident-esc? ac) (eq? (get-kind ac) 'sv-let-ident-esc))
(define (named-let-ident-esc? ac) (eq? (get-kind ac) 'named-let-ident-esc))
(define (lambda-bind-ident-esc? ac) (eq? (get-kind ac) 'lambda-bind-ident-esc))
(define (lambda-rest-ident-esc? ac) (eq? (get-kind ac) 'lambda-rest-ident-esc))
(define (mv-let-ident-esc? ac) (eq? (get-kind ac) 'mv-let-ident-esc))
(define (mv-define-ident-esc? ac) (eq? (get-kind ac) 'mv-define-ident-esc))
(define (case-lambda-bind-ident-esc? ac)
  (eq? (get-kind ac) 'case-lambda-bind-ident-esc))
(define (case-lambda-rest-ident-esc? ac)
  (eq? (get-kind ac) 'case-lambda-rest-ident-esc))

(define (^invalidate/maybe-end! base-sym delim-char predicate?)
  (lambda (ac-list nc)
    (revise-while! ac-list base-sym predicate?)
    (cond ((char=? nc delim-char) (end-symmetric! ac-list nc base-sym))
          (else (adorn-char nc 'invalid base-sym)))))

(define invalidate/maybe-end-string-esc!
  (^invalidate/maybe-end! 'string #\" string-esc?))
(define invalidate/maybe-end-ident-esc!
  (^invalidate/maybe-end! 'ident #\| ident-esc?))
(define invalidate/maybe-end-sv-define-ident-esc!
  (^invalidate/maybe-end! 'sv-define-ident #\| sv-define-ident-esc?))
(define invalidate/maybe-end-defun-param-ident-esc!
  (^invalidate/maybe-end! 'defun-param-ident #\| defun-param-ident-esc?))
(define invalidate/maybe-end-defun-proc-ident-esc!
  (^invalidate/maybe-end! 'defun-proc-ident #\| defun-proc-ident-esc?))
(define invalidate/maybe-end-sv-let-ident-esc!
  (^invalidate/maybe-end! 'sv-let-ident #\| sv-let-ident-esc?))
(define invalidate/maybe-end-named-let-ident-esc!
  (^invalidate/maybe-end! 'named-let-ident #\| named-let-ident-esc?))
(define invalidate/maybe-end-lambda-bind-ident-esc!
  (^invalidate/maybe-end! 'lambda-bind-ident #\| lambda-bind-ident-esc?))
(define invalidate/maybe-end-lambda-rest-ident-esc!
  (^invalidate/maybe-end! 'lambda-rest-ident #\| lambda-rest-ident-esc?))
(define invalidate/maybe-end-mv-let-ident-esc!
  (^invalidate/maybe-end! 'mv-let-ident #\| mv-let-ident-esc?))
(define invalidate/maybe-end-mv-define-ident-esc!
  (^invalidate/maybe-end! 'mv-define-ident #\| mv-define-ident-esc?))
(define invalidate/maybe-end-case-lambda-bind-ident-esc!
  (^invalidate/maybe-end! 'case-lambda-bind #\| case-lambda-bind-ident-esc?))
(define invalidate/maybe-end-case-lambda-rest-ident-esc!
  (^invalidate/maybe-end! 'case-lambda-rest #\| case-lambda-rest-ident-esc?))

(define (^handle:symmetric! base-sym backslash-sym esc-sym delim-char)
  (lambda (ac-list nc)
    (cond ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          ((char=? nc delim-char) (end-symmetric! ac-list nc base-sym))
          (else (adorn-char nc base-sym base-sym)))))

(define (^handle:symmetric-backslash! base-sym esc-sym hex-x-sym hex-u-sym
                                      hex-U-sym nil-sym
                                      octal-long-sym octal-short-sym
                                      invalidate/maybe-end!)
  (lambda (ac-list nc)
    (cond ((char=? nc #\x) (adorn-char nc esc-sym hex-x-sym))
          ((char=? nc #\u) (adorn-char nc esc-sym hex-u-sym))
          ((char=? nc #\U) (adorn-char nc esc-sym hex-U-sym))
          ((char=? nc #\newline) (adorn-char nc esc-sym nil-sym))
          ((memc nc mnemonic-escape-chars) (adorn-char nc esc-sym base-sym))
          ((memc nc '(#\0 #\1 #\2 #\3))
           (adorn-char nc esc-sym octal-long-sym))
          ((memc nc '(#\4 #\5 #\6 #\7))
           (adorn-char nc esc-sym octal-short-sym))
          (else (invalidate/maybe-end! ac-list nc)))))

(define (^handle:symmetric-nil! delim-char base-sym backslash-sym esc-sym
                                nil-sym)
  (lambda (ac-list nc)
    (cond ((memc nc '(#\space #\tab)) (adorn-char nc esc-sym nil-sym))
          ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          ((char=? nc delim-char) (end-symmetric! ac-list nc base-sym))
          (else (adorn-char nc base-sym base-sym)))))

(define (^handle:symmetric-hex-x! base-sym esc-sym hex-x-sym
                                  invalidate/maybe-end!)
  (lambda (ac-list nc)
    (cond ((char=? nc #\;) (adorn-char nc esc-sym base-sym))
          ((memc-ci nc hexadecimal-chars)
           (adorn-char nc esc-sym hex-x-sym))
          (else (invalidate/maybe-end! ac-list nc)))))

(define (^handle:symmetric-octal-long! delim-char base-sym backslash-sym
                                       esc-sym next-sym)
  (lambda (ac-list nc)
    (cond ((memc nc octal-chars) (adorn-char nc esc-sym next-sym))
          ((char=? nc delim-char) (end-symmetric! ac-list nc base-sym))
          ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          (else (adorn-char nc base-sym base-sym)))))

(define (^handle:symmetric-octal-long1! delim-char base-sym backslash-sym
                                        esc-sym)
  (lambda (ac-list nc)
    (cond ((memc nc octal-chars) (adorn-char nc esc-sym base-sym))
          ((char=? nc delim-char) (end-symmetric! ac-list nc base-sym))
          ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          (else (adorn-char nc base-sym base-sym)))))

(define (^handle:symmetric-octal-short! delim-char base-sym backslash-sym
                                        esc-sym)
  (lambda (ac-list nc)
    (cond ((memc nc octal-chars) (adorn-char nc esc-sym base-sym))
          ((char=? nc #\") (end-symmetric! ac-list nc base-sym))
          ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          (else (adorn-char nc base-sym base-sym)))))

(define (^handle:symmetric-hex-Uu! esc-sym next-sym invalidate/maybe-end!)
  (lambda (ac-list nc)
    (cond ((memc-ci nc hexadecimal-chars) (adorn-char nc esc-sym next-sym))
          (else (invalidate/maybe-end! ac-list nc)))))

(define (^handle:symmetric-esc! backslash-sym backslash-handler
                                nil-sym nil-handler
                                hex-x-sym hex-x-handler
                                hex-u-sym hex-u-handler
                                hex-u1-sym hex-u1-handler
                                hex-u2-sym hex-u2-handler
                                hex-u3-sym hex-u3-handler
                                hex-U-sym hex-U-handler
                                hex-U1-sym hex-U1-handler
                                hex-U2-sym hex-U2-handler
                                hex-U3-sym hex-U3-handler
                                hex-U4-sym hex-U4-handler
                                hex-U5-sym hex-U5-handler
                                hex-U6-sym hex-U6-handler
                                hex-U7-sym hex-U7-handler
                                octal-long-sym octal-long-handler
                                octal-long1-sym octal-long1-handler
                                octal-short-sym octal-short-handler)
  (lambda (ac-list nc pm)
    (cond ((eq? pm backslash-sym)    (backslash-handler ac-list nc))
          ((eq? pm nil-sym)          (nil-handler ac-list nc))
          ((eq? pm hex-x-sym)        (hex-x-handler ac-list nc))
          ((eq? pm octal-long-sym)   (octal-long-handler ac-list nc))
          ((eq? pm octal-long1-sym)  (octal-long1-handler ac-list nc))
          ((eq? pm octal-short-sym)  (octal-short-handler ac-list nc))
          ((eq? pm hex-u-sym)        (hex-u-handler ac-list nc))
          ((eq? pm hex-u1-sym)       (hex-u1-handler ac-list nc))
          ((eq? pm hex-u2-sym)       (hex-u2-handler ac-list nc))
          ((eq? pm hex-u3-sym)       (hex-u3-handler ac-list nc))
          ((eq? pm hex-U-sym)        (hex-U-handler ac-list nc))
          ((eq? pm hex-U1-sym)       (hex-U1-handler ac-list nc))
          ((eq? pm hex-U2-sym)       (hex-U2-handler ac-list nc))
          ((eq? pm hex-U3-sym)       (hex-U3-handler ac-list nc))
          ((eq? pm hex-U4-sym)       (hex-U4-handler ac-list nc))
          ((eq? pm hex-U5-sym)       (hex-U5-handler ac-list nc))
          ((eq? pm hex-U6-sym)       (hex-U6-handler ac-list nc))
          ((eq? pm hex-U7-sym)       (hex-U7-handler ac-list nc))
          (else #f))))

(define-macro (define-symmetric-handlers
                delim-char
                base-sym base-handler
                backslash-sym backslash-handler
                esc-sym esc-handler
                invalidate/maybe-end!
                u-sym u-handler
                u1-sym u1-handler
                u2-sym u2-handler
                u3-sym u3-handler
                U-sym U-handler
                U1-sym U1-handler
                U2-sym U2-handler
                U3-sym U3-handler
                U4-sym U4-handler
                U5-sym U5-handler
                U6-sym U6-handler
                U7-sym U7-handler
                x-sym x-handler
                nil-sym nil-handler
                octal-short-sym octal-short-handler
                octal-long-sym octal-long-handler
                octal-long1-sym octal-long1-handler)
  `(begin (define ,base-handler (^handle:symmetric! ,base-sym ,backslash-sym
                                                    ,esc-sym ,delim-char))
          (define ,u-handler (^handle:symmetric-hex-Uu!
                              ,esc-sym ,u1-sym ,invalidate/maybe-end!))
          (define ,u1-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,u2-sym ,invalidate/maybe-end!))
          (define ,u2-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,u3-sym ,invalidate/maybe-end!))
          (define ,u3-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,base-sym ,invalidate/maybe-end!))
          (define ,U-handler (^handle:symmetric-hex-Uu!
                              ,esc-sym ,U1-sym ,invalidate/maybe-end!))
          (define ,U1-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,U2-sym ,invalidate/maybe-end!))
          (define ,U2-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,U3-sym ,invalidate/maybe-end!))
          (define ,U3-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,U4-sym ,invalidate/maybe-end!))
          (define ,U4-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,U5-sym ,invalidate/maybe-end!))
          (define ,U5-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,U6-sym ,invalidate/maybe-end!))
          (define ,U6-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,U7-sym ,invalidate/maybe-end!))
          (define ,U7-handler (^handle:symmetric-hex-Uu!
                               ,esc-sym ,base-sym ,invalidate/maybe-end!))
          (define ,x-handler (^handle:symmetric-hex-x!
                              ,base-sym ,esc-sym ,x-sym
                              ,invalidate/maybe-end!))
          (define ,nil-handler (^handle:symmetric-nil!
                                ,delim-char ,base-sym ,backslash-sym
                                ,esc-sym ,nil-sym))
          (define ,octal-short-handler (^handle:symmetric-octal-short!
                                        ,delim-char ,base-sym ,backslash-sym
                                        ,esc-sym))
          (define ,octal-long-handler (^handle:symmetric-octal-long!
                                       ,delim-char ,base-sym ,backslash-sym
                                       ,esc-sym ,octal-long1-sym))
          (define ,octal-long1-handler (^handle:symmetric-octal-long1!
                                        ,delim-char ,base-sym ,backslash-sym
                                        ,esc-sym))
          (define ,backslash-handler (^handle:symmetric-backslash!
                                      ,base-sym ,esc-sym ,x-sym ,u-sym
                                      ,U-sym ,nil-sym ,octal-long-sym
                                      ,octal-short-sym
                                      ,invalidate/maybe-end!))
          (define ,esc-handler (^handle:symmetric-esc!
                                ,backslash-sym ,backslash-handler
                                ,nil-sym ,nil-handler
                                ,x-sym ,x-handler
                                ,u-sym ,u-handler
                                ,u1-sym ,u1-handler
                                ,u2-sym ,u2-handler
                                ,u3-sym ,u3-handler
                                ,U-sym ,U-handler
                                ,U1-sym ,U1-handler
                                ,U2-sym ,U2-handler
                                ,U3-sym ,U3-handler
                                ,U4-sym ,U4-handler
                                ,U5-sym ,U5-handler
                                ,U6-sym ,U6-handler
                                ,U7-sym ,U7-handler
                                ,octal-long-sym ,octal-long-handler
                                ,octal-long1-sym ,octal-long1-handler
                                ,octal-short-sym ,octal-short-handler))))

(define-symmetric-handlers
  #\"
  'string handle:string!
  'string-backslash handle:string-backslash!
  'string-esc handle:string-esc!
  invalidate/maybe-end-string-esc!
  'string-hex-u handle:string-hex-u!
  'string-hex-u1 handle:string-hex-u1!
  'string-hex-u2 handle:string-hex-u2!
  'string-hex-u3 handle:string-hex-u3!
  'string-hex-U handle:string-hex-U!
  'string-hex-U1 handle:string-hex-U1!
  'string-hex-U2 handle:string-hex-U2!
  'string-hex-U3 handle:string-hex-U3!
  'string-hex-U4 handle:string-hex-U4!
  'string-hex-U5 handle:string-hex-U5!
  'string-hex-U6 handle:string-hex-U6!
  'string-hex-U7 handle:string-hex-U7!
  'string-hex-x handle:string-hex-x!
  'string-nil handle:string-nil!
  'string-octal-short handle:string-octal-short!
  'string-octal-long handle:string-octal-long!
  'string-octal-long1 handle:string-octal-long1!)

(define (try-string-pm! ac-list nc pac pm)
  (cond ((memq pm '(string string-unmatched)) (handle:string! ac-list nc))
        ((eq? (get-kind pac) 'string-esc) (handle:string-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'ident handle:ident!
  'ident-backslash handle:ident-backslash!
  'ident-esc handle:ident-esc!
  invalidate/maybe-end-ident-esc!
  'ident-hex-u handle:ident-hex-u!
  'ident-hex-u1 handle:ident-hex-u1!
  'ident-hex-u2 handle:ident-hex-u2!
  'ident-hex-u3 handle:ident-hex-u3!
  'ident-hex-U handle:ident-hex-U!
  'ident-hex-U1 handle:ident-hex-U1!
  'ident-hex-U2 handle:ident-hex-U2!
  'ident-hex-U3 handle:ident-hex-U3!
  'ident-hex-U4 handle:ident-hex-U4!
  'ident-hex-U5 handle:ident-hex-U5!
  'ident-hex-U6 handle:ident-hex-U6!
  'ident-hex-U7 handle:ident-hex-U7!
  'ident-hex-x handle:ident-hex-x!
  'ident-nil handle:ident-nil!
  'ident-octal-short handle:ident-octal-short!
  'ident-octal-long handle:ident-octal-long!
  'ident-octal-long1 handle:ident-octal-long1!)

(define-symmetric-handlers
  #\|
  'ident handle:ident!
  'ident-backslash handle:ident-backslash!
  'ident-esc handle:ident-esc!
  invalidate/maybe-end-ident-esc!
  'ident-hex-u handle:ident-hex-u!
  'ident-hex-u1 handle:ident-hex-u1!
  'ident-hex-u2 handle:ident-hex-u2!
  'ident-hex-u3 handle:ident-hex-u3!
  'ident-hex-U handle:ident-hex-U!
  'ident-hex-U1 handle:ident-hex-U1!
  'ident-hex-U2 handle:ident-hex-U2!
  'ident-hex-U3 handle:ident-hex-U3!
  'ident-hex-U4 handle:ident-hex-U4!
  'ident-hex-U5 handle:ident-hex-U5!
  'ident-hex-U6 handle:ident-hex-U6!
  'ident-hex-U7 handle:ident-hex-U7!
  'ident-hex-x handle:ident-hex-x!
  'ident-nil handle:ident-nil!
  'ident-octal-short handle:ident-octal-short!
  'ident-octal-long handle:ident-octal-long!
  'ident-octal-long1 handle:ident-octal-long1!)

(define (try-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(ident ident-unmatched)) (handle:ident! ac-list nc))
        ((eq? (get-kind pac) 'ident-esc) (handle:ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'sv-define-ident handle:sv-define-ident!
  'sv-define-ident-backslash handle:sv-define-ident-backslash!
  'sv-define-ident-esc handle:sv-define-ident-esc!
  invalidate/maybe-end-sv-define-ident-esc!
  'sv-define-ident-hex-u handle:sv-define-ident-hex-u!
  'sv-define-ident-hex-u1 handle:sv-define-ident-hex-u1!
  'sv-define-ident-hex-u2 handle:sv-define-ident-hex-u2!
  'sv-define-ident-hex-u3 handle:sv-define-ident-hex-u3!
  'sv-define-ident-hex-U handle:sv-define-ident-hex-U!
  'sv-define-ident-hex-U1 handle:sv-define-ident-hex-U1!
  'sv-define-ident-hex-U2 handle:sv-define-ident-hex-U2!
  'sv-define-ident-hex-U3 handle:sv-define-ident-hex-U3!
  'sv-define-ident-hex-U4 handle:sv-define-ident-hex-U4!
  'sv-define-ident-hex-U5 handle:sv-define-ident-hex-U5!
  'sv-define-ident-hex-U6 handle:sv-define-ident-hex-U6!
  'sv-define-ident-hex-U7 handle:sv-define-ident-hex-U7!
  'sv-define-ident-hex-x handle:sv-define-ident-hex-x!
  'sv-define-ident-nil handle:sv-define-ident-nil!
  'sv-define-ident-octal-short handle:sv-define-ident-octal-short!
  'sv-define-ident-octal-long handle:sv-define-ident-octal-long!
  'sv-define-ident-octal-long1 handle:sv-define-ident-octal-long1!)

(define (try-sv-define-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(sv-define-ident sv-define-ident-unmatched))
         (handle:sv-define-ident! ac-list nc))
        ((eq? (get-kind pac) 'sv-define-ident-esc)
         (handle:sv-define-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'defun-param-ident handle:defun-param-ident!
  'defun-param-ident-backslash handle:defun-param-ident-backslash!
  'defun-param-ident-esc handle:defun-param-ident-esc!
  invalidate/maybe-end-defun-param-ident-esc!
  'defun-param-ident-hex-u handle:defun-param-ident-hex-u!
  'defun-param-ident-hex-u1 handle:defun-param-ident-hex-u1!
  'defun-param-ident-hex-u2 handle:defun-param-ident-hex-u2!
  'defun-param-ident-hex-u3 handle:defun-param-ident-hex-u3!
  'defun-param-ident-hex-U handle:defun-param-ident-hex-U!
  'defun-param-ident-hex-U1 handle:defun-param-ident-hex-U1!
  'defun-param-ident-hex-U2 handle:defun-param-ident-hex-U2!
  'defun-param-ident-hex-U3 handle:defun-param-ident-hex-U3!
  'defun-param-ident-hex-U4 handle:defun-param-ident-hex-U4!
  'defun-param-ident-hex-U5 handle:defun-param-ident-hex-U5!
  'defun-param-ident-hex-U6 handle:defun-param-ident-hex-U6!
  'defun-param-ident-hex-U7 handle:defun-param-ident-hex-U7!
  'defun-param-ident-hex-x handle:defun-param-ident-hex-x!
  'defun-param-ident-nil handle:defun-param-ident-nil!
  'defun-param-ident-octal-short handle:defun-param-ident-octal-short!
  'defun-param-ident-octal-long handle:defun-param-ident-octal-long!
  'defun-param-ident-octal-long1 handle:defun-param-ident-octal-long1!)

(define (try-defun-param-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(defun-param-ident defun-param-ident-unmatched))
         (handle:defun-param-ident! ac-list nc))
        ((eq? (get-kind pac) 'defun-param-ident-esc)
         (handle:defun-param-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'defun-proc-ident handle:defun-proc-ident!
  'defun-proc-ident-backslash handle:defun-proc-ident-backslash!
  'defun-proc-ident-esc handle:defun-proc-ident-esc!
  invalidate/maybe-end-defun-proc-ident-esc!
  'defun-proc-ident-hex-u handle:defun-proc-ident-hex-u!
  'defun-proc-ident-hex-u1 handle:defun-proc-ident-hex-u1!
  'defun-proc-ident-hex-u2 handle:defun-proc-ident-hex-u2!
  'defun-proc-ident-hex-u3 handle:defun-proc-ident-hex-u3!
  'defun-proc-ident-hex-U handle:defun-proc-ident-hex-U!
  'defun-proc-ident-hex-U1 handle:defun-proc-ident-hex-U1!
  'defun-proc-ident-hex-U2 handle:defun-proc-ident-hex-U2!
  'defun-proc-ident-hex-U3 handle:defun-proc-ident-hex-U3!
  'defun-proc-ident-hex-U4 handle:defun-proc-ident-hex-U4!
  'defun-proc-ident-hex-U5 handle:defun-proc-ident-hex-U5!
  'defun-proc-ident-hex-U6 handle:defun-proc-ident-hex-U6!
  'defun-proc-ident-hex-U7 handle:defun-proc-ident-hex-U7!
  'defun-proc-ident-hex-x handle:defun-proc-ident-hex-x!
  'defun-proc-ident-nil handle:defun-proc-ident-nil!
  'defun-proc-ident-octal-short handle:defun-proc-ident-octal-short!
  'defun-proc-ident-octal-long handle:defun-proc-ident-octal-long!
  'defun-proc-ident-octal-long1 handle:defun-proc-ident-octal-long1!)

(define (try-defun-proc-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(defun-proc-ident defun-proc-ident-unmatched))
         (handle:defun-proc-ident! ac-list nc))
        ((eq? (get-kind pac) 'defun-proc-ident-esc)
         (handle:defun-proc-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'sv-let-ident handle:sv-let-ident!
  'sv-let-ident-backslash handle:sv-let-ident-backslash!
  'sv-let-ident-esc handle:sv-let-ident-esc!
  invalidate/maybe-end-sv-let-ident-esc!
  'sv-let-ident-hex-u handle:sv-let-ident-hex-u!
  'sv-let-ident-hex-u1 handle:sv-let-ident-hex-u1!
  'sv-let-ident-hex-u2 handle:sv-let-ident-hex-u2!
  'sv-let-ident-hex-u3 handle:sv-let-ident-hex-u3!
  'sv-let-ident-hex-U handle:sv-let-ident-hex-U!
  'sv-let-ident-hex-U1 handle:sv-let-ident-hex-U1!
  'sv-let-ident-hex-U2 handle:sv-let-ident-hex-U2!
  'sv-let-ident-hex-U3 handle:sv-let-ident-hex-U3!
  'sv-let-ident-hex-U4 handle:sv-let-ident-hex-U4!
  'sv-let-ident-hex-U5 handle:sv-let-ident-hex-U5!
  'sv-let-ident-hex-U6 handle:sv-let-ident-hex-U6!
  'sv-let-ident-hex-U7 handle:sv-let-ident-hex-U7!
  'sv-let-ident-hex-x handle:sv-let-ident-hex-x!
  'sv-let-ident-nil handle:sv-let-ident-nil!
  'sv-let-ident-octal-short handle:sv-let-ident-octal-short!
  'sv-let-ident-octal-long handle:sv-let-ident-octal-long!
  'sv-let-ident-octal-long1 handle:sv-let-ident-octal-long1!)

(define (try-sv-let-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(sv-let-ident sv-let-ident-unmatched))
         (handle:sv-let-ident! ac-list nc))
        ((eq? (get-kind pac) 'sv-let-ident-esc)
         (handle:sv-let-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'named-let-ident handle:named-let-ident!
  'named-let-ident-backslash handle:named-let-ident-backslash!
  'named-let-ident-esc handle:named-let-ident-esc!
  invalidate/maybe-end-named-let-ident-esc!
  'named-let-ident-hex-u handle:named-let-ident-hex-u!
  'named-let-ident-hex-u1 handle:named-let-ident-hex-u1!
  'named-let-ident-hex-u2 handle:named-let-ident-hex-u2!
  'named-let-ident-hex-u3 handle:named-let-ident-hex-u3!
  'named-let-ident-hex-U handle:named-let-ident-hex-U!
  'named-let-ident-hex-U1 handle:named-let-ident-hex-U1!
  'named-let-ident-hex-U2 handle:named-let-ident-hex-U2!
  'named-let-ident-hex-U3 handle:named-let-ident-hex-U3!
  'named-let-ident-hex-U4 handle:named-let-ident-hex-U4!
  'named-let-ident-hex-U5 handle:named-let-ident-hex-U5!
  'named-let-ident-hex-U6 handle:named-let-ident-hex-U6!
  'named-let-ident-hex-U7 handle:named-let-ident-hex-U7!
  'named-let-ident-hex-x handle:named-let-ident-hex-x!
  'named-let-ident-nil handle:named-let-ident-nil!
  'named-let-ident-octal-short handle:named-let-ident-octal-short!
  'named-let-ident-octal-long handle:named-let-ident-octal-long!
  'named-let-ident-octal-long1 handle:named-let-ident-octal-long1!)

(define (try-named-let-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(named-let-ident named-let-ident-unmatched))
         (handle:named-let-ident! ac-list nc))
        ((eq? (get-kind pac) 'named-let-ident-esc)
         (handle:named-let-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'lambda-bind-ident handle:lambda-bind-ident!
  'lambda-bind-ident-backslash handle:lambda-bind-ident-backslash!
  'lambda-bind-ident-esc handle:lambda-bind-ident-esc!
  invalidate/maybe-end-lambda-bind-ident-esc!
  'lambda-bind-ident-hex-u handle:lambda-bind-ident-hex-u!
  'lambda-bind-ident-hex-u1 handle:lambda-bind-ident-hex-u1!
  'lambda-bind-ident-hex-u2 handle:lambda-bind-ident-hex-u2!
  'lambda-bind-ident-hex-u3 handle:lambda-bind-ident-hex-u3!
  'lambda-bind-ident-hex-U handle:lambda-bind-ident-hex-U!
  'lambda-bind-ident-hex-U1 handle:lambda-bind-ident-hex-U1!
  'lambda-bind-ident-hex-U2 handle:lambda-bind-ident-hex-U2!
  'lambda-bind-ident-hex-U3 handle:lambda-bind-ident-hex-U3!
  'lambda-bind-ident-hex-U4 handle:lambda-bind-ident-hex-U4!
  'lambda-bind-ident-hex-U5 handle:lambda-bind-ident-hex-U5!
  'lambda-bind-ident-hex-U6 handle:lambda-bind-ident-hex-U6!
  'lambda-bind-ident-hex-U7 handle:lambda-bind-ident-hex-U7!
  'lambda-bind-ident-hex-x handle:lambda-bind-ident-hex-x!
  'lambda-bind-ident-nil handle:lambda-bind-ident-nil!
  'lambda-bind-ident-octal-short handle:lambda-bind-ident-octal-short!
  'lambda-bind-ident-octal-long handle:lambda-bind-ident-octal-long!
  'lambda-bind-ident-octal-long1 handle:lambda-bind-ident-octal-long1!)

(define (try-lambda-bind-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(lambda-bind-ident lambda-bind-ident-unmatched))
         (handle:lambda-bind-ident! ac-list nc))
        ((eq? (get-kind pac) 'lambda-bind-ident-esc)
         (handle:lambda-bind-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'lambda-rest-ident handle:lambda-rest-ident!
  'lambda-rest-ident-backslash handle:lambda-rest-ident-backslash!
  'lambda-rest-ident-esc handle:lambda-rest-ident-esc!
  invalidate/maybe-end-lambda-rest-ident-esc!
  'lambda-rest-ident-hex-u handle:lambda-rest-ident-hex-u!
  'lambda-rest-ident-hex-u1 handle:lambda-rest-ident-hex-u1!
  'lambda-rest-ident-hex-u2 handle:lambda-rest-ident-hex-u2!
  'lambda-rest-ident-hex-u3 handle:lambda-rest-ident-hex-u3!
  'lambda-rest-ident-hex-U handle:lambda-rest-ident-hex-U!
  'lambda-rest-ident-hex-U1 handle:lambda-rest-ident-hex-U1!
  'lambda-rest-ident-hex-U2 handle:lambda-rest-ident-hex-U2!
  'lambda-rest-ident-hex-U3 handle:lambda-rest-ident-hex-U3!
  'lambda-rest-ident-hex-U4 handle:lambda-rest-ident-hex-U4!
  'lambda-rest-ident-hex-U5 handle:lambda-rest-ident-hex-U5!
  'lambda-rest-ident-hex-U6 handle:lambda-rest-ident-hex-U6!
  'lambda-rest-ident-hex-U7 handle:lambda-rest-ident-hex-U7!
  'lambda-rest-ident-hex-x handle:lambda-rest-ident-hex-x!
  'lambda-rest-ident-nil handle:lambda-rest-ident-nil!
  'lambda-rest-ident-octal-short handle:lambda-rest-ident-octal-short!
  'lambda-rest-ident-octal-long handle:lambda-rest-ident-octal-long!
  'lambda-rest-ident-octal-long1 handle:lambda-rest-ident-octal-long1!)

(define (try-lambda-rest-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(lambda-rest-ident lambda-rest-ident-unmatched))
         (handle:lambda-rest-ident! ac-list nc))
        ((eq? (get-kind pac) 'lambda-rest-ident-esc)
         (handle:lambda-rest-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'mv-let-ident handle:mv-let-ident!
  'mv-let-ident-backslash handle:mv-let-ident-backslash!
  'mv-let-ident-esc handle:mv-let-ident-esc!
  invalidate/maybe-end-mv-let-ident-esc!
  'mv-let-ident-hex-u handle:mv-let-ident-hex-u!
  'mv-let-ident-hex-u1 handle:mv-let-ident-hex-u1!
  'mv-let-ident-hex-u2 handle:mv-let-ident-hex-u2!
  'mv-let-ident-hex-u3 handle:mv-let-ident-hex-u3!
  'mv-let-ident-hex-U handle:mv-let-ident-hex-U!
  'mv-let-ident-hex-U1 handle:mv-let-ident-hex-U1!
  'mv-let-ident-hex-U2 handle:mv-let-ident-hex-U2!
  'mv-let-ident-hex-U3 handle:mv-let-ident-hex-U3!
  'mv-let-ident-hex-U4 handle:mv-let-ident-hex-U4!
  'mv-let-ident-hex-U5 handle:mv-let-ident-hex-U5!
  'mv-let-ident-hex-U6 handle:mv-let-ident-hex-U6!
  'mv-let-ident-hex-U7 handle:mv-let-ident-hex-U7!
  'mv-let-ident-hex-x handle:mv-let-ident-hex-x!
  'mv-let-ident-nil handle:mv-let-ident-nil!
  'mv-let-ident-octal-short handle:mv-let-ident-octal-short!
  'mv-let-ident-octal-long handle:mv-let-ident-octal-long!
  'mv-let-ident-octal-long1 handle:mv-let-ident-octal-long1!)

(define (try-mv-let-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(mv-let-ident mv-let-ident-unmatched))
         (handle:mv-let-ident! ac-list nc))
        ((eq? (get-kind pac) 'mv-let-ident-esc)
         (handle:mv-let-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'mv-define-ident handle:mv-define-ident!
  'mv-define-ident-backslash handle:mv-define-ident-backslash!
  'mv-define-ident-esc handle:mv-define-ident-esc!
  invalidate/maybe-end-mv-define-ident-esc!
  'mv-define-ident-hex-u handle:mv-define-ident-hex-u!
  'mv-define-ident-hex-u1 handle:mv-define-ident-hex-u1!
  'mv-define-ident-hex-u2 handle:mv-define-ident-hex-u2!
  'mv-define-ident-hex-u3 handle:mv-define-ident-hex-u3!
  'mv-define-ident-hex-U handle:mv-define-ident-hex-U!
  'mv-define-ident-hex-U1 handle:mv-define-ident-hex-U1!
  'mv-define-ident-hex-U2 handle:mv-define-ident-hex-U2!
  'mv-define-ident-hex-U3 handle:mv-define-ident-hex-U3!
  'mv-define-ident-hex-U4 handle:mv-define-ident-hex-U4!
  'mv-define-ident-hex-U5 handle:mv-define-ident-hex-U5!
  'mv-define-ident-hex-U6 handle:mv-define-ident-hex-U6!
  'mv-define-ident-hex-U7 handle:mv-define-ident-hex-U7!
  'mv-define-ident-hex-x handle:mv-define-ident-hex-x!
  'mv-define-ident-nil handle:mv-define-ident-nil!
  'mv-define-ident-octal-short handle:mv-define-ident-octal-short!
  'mv-define-ident-octal-long handle:mv-define-ident-octal-long!
  'mv-define-ident-octal-long1 handle:mv-define-ident-octal-long1!)

(define (try-mv-define-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(mv-define-ident mv-define-ident-unmatched))
         (handle:mv-define-ident! ac-list nc))
        ((eq? (get-kind pac) 'mv-define-ident-esc)
         (handle:mv-define-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'case-lambda-bind-ident handle:case-lambda-bind-ident!
  'case-lambda-bind-ident-backslash handle:case-lambda-bind-ident-backslash!
  'case-lambda-bind-ident-esc handle:case-lambda-bind-ident-esc!
  invalidate/maybe-end-case-lambda-bind-ident-esc!
  'case-lambda-bind-ident-hex-u handle:case-lambda-bind-ident-hex-u!
  'case-lambda-bind-ident-hex-u1 handle:case-lambda-bind-ident-hex-u1!
  'case-lambda-bind-ident-hex-u2 handle:case-lambda-bind-ident-hex-u2!
  'case-lambda-bind-ident-hex-u3 handle:case-lambda-bind-ident-hex-u3!
  'case-lambda-bind-ident-hex-U handle:case-lambda-bind-ident-hex-U!
  'case-lambda-bind-ident-hex-U1 handle:case-lambda-bind-ident-hex-U1!
  'case-lambda-bind-ident-hex-U2 handle:case-lambda-bind-ident-hex-U2!
  'case-lambda-bind-ident-hex-U3 handle:case-lambda-bind-ident-hex-U3!
  'case-lambda-bind-ident-hex-U4 handle:case-lambda-bind-ident-hex-U4!
  'case-lambda-bind-ident-hex-U5 handle:case-lambda-bind-ident-hex-U5!
  'case-lambda-bind-ident-hex-U6 handle:case-lambda-bind-ident-hex-U6!
  'case-lambda-bind-ident-hex-U7 handle:case-lambda-bind-ident-hex-U7!
  'case-lambda-bind-ident-hex-x handle:case-lambda-bind-ident-hex-x!
  'case-lambda-bind-ident-nil handle:case-lambda-bind-ident-nil!
  'case-lambda-bind-ident-octal-short
  handle:case-lambda-bind-ident-octal-short!
  'case-lambda-bind-ident-octal-long
  handle:case-lambda-bind-ident-octal-long!
  'case-lambda-bind-ident-octal-long1
  handle:case-lambda-bind-ident-octal-long1!)

(define (try-case-lambda-bind-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(case-lambda-bind-ident case-lambda-bind-ident-unmatched))
         (handle:case-lambda-bind-ident! ac-list nc))
        ((eq? (get-kind pac) 'case-lambda-bind-ident-esc)
         (handle:case-lambda-bind-ident-esc! ac-list nc pm))
        (else #f)))

(define-symmetric-handlers
  #\|
  'case-lambda-rest-ident handle:case-lambda-rest-ident!
  'case-lambda-rest-ident-backslash handle:case-lambda-rest-ident-backslash!
  'case-lambda-rest-ident-esc handle:case-lambda-rest-ident-esc!
  invalidate/maybe-end-case-lambda-rest-ident-esc!
  'case-lambda-rest-ident-hex-u handle:case-lambda-rest-ident-hex-u!
  'case-lambda-rest-ident-hex-u1 handle:case-lambda-rest-ident-hex-u1!
  'case-lambda-rest-ident-hex-u2 handle:case-lambda-rest-ident-hex-u2!
  'case-lambda-rest-ident-hex-u3 handle:case-lambda-rest-ident-hex-u3!
  'case-lambda-rest-ident-hex-U handle:case-lambda-rest-ident-hex-U!
  'case-lambda-rest-ident-hex-U1 handle:case-lambda-rest-ident-hex-U1!
  'case-lambda-rest-ident-hex-U2 handle:case-lambda-rest-ident-hex-U2!
  'case-lambda-rest-ident-hex-U3 handle:case-lambda-rest-ident-hex-U3!
  'case-lambda-rest-ident-hex-U4 handle:case-lambda-rest-ident-hex-U4!
  'case-lambda-rest-ident-hex-U5 handle:case-lambda-rest-ident-hex-U5!
  'case-lambda-rest-ident-hex-U6 handle:case-lambda-rest-ident-hex-U6!
  'case-lambda-rest-ident-hex-U7 handle:case-lambda-rest-ident-hex-U7!
  'case-lambda-rest-ident-hex-x handle:case-lambda-rest-ident-hex-x!
  'case-lambda-rest-ident-nil handle:case-lambda-rest-ident-nil!
  'case-lambda-rest-ident-octal-short
  handle:case-lambda-rest-ident-octal-short!
  'case-lambda-rest-ident-octal-long
  handle:case-lambda-rest-ident-octal-long!
  'case-lambda-rest-ident-octal-long1
  handle:case-lambda-rest-ident-octal-long1!)

(define (try-case-lambda-rest-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(case-lambda-rest-ident case-lambda-rest-ident-unmatched))
         (handle:case-lambda-rest-ident! ac-list nc))
        ((eq? (get-kind pac) 'case-lambda-rest-ident-esc)
         (handle:case-lambda-rest-ident-esc! ac-list nc pm))
        (else #f)))

(define (try-symmetric-pm! ac-list nc pac pm)
  (or (try-string-pm! ac-list nc pac pm)
      (try-ident-pm! ac-list nc pac pm)
      (try-sv-define-ident-pm! ac-list nc pac pm)
      (try-defun-param-ident-pm! ac-list nc pac pm)
      (try-defun-proc-ident-pm! ac-list nc pac pm)
      (try-sv-let-ident-pm! ac-list nc pac pm)
      (try-named-let-ident-pm! ac-list nc pac pm)
      (try-lambda-bind-ident-pm! ac-list nc pac pm)
      (try-lambda-rest-ident-pm! ac-list nc pac pm)
      (try-mv-let-ident-pm! ac-list nc pac pm)
      (try-mv-define-ident-pm! ac-list nc pac pm)
      (try-case-lambda-bind-ident-pm! ac-list nc pac pm)
      (try-case-lambda-rest-ident-pm! ac-list nc pac pm)
      #f))
