;; '( sv-define defun-param defun-proc sv-let named-let lambda-bind
;;    lambda-rest mv-let mv-define case-lambda-bind case-lambda-rest )

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
(define invalidate/maybe-end-case-lambda-bind-esc!
  (^invalidate/maybe-end! 'case-lambda-bind #\| case-lambda-bind-ident-esc?))
(define invalidate/maybe-end-case-lambda-rest-esc!
  (^invalidate/maybe-end! 'case-lambda-rest #\| case-lambda-rest-ident-esc?))

(define (handle:string! ac-list nc)
  (cond ((char=? nc #\\) (adorn-char nc 'string-esc 'string-backslash))
        ((char=? nc #\") (end-symmetric! ac-list nc 'string))
        (else (adorn-char nc 'string 'string))))

(define (handle:string-esc! ac-list nc pm)
  (cond ((eq? pm 'string-backslash)    (handle:string-backslash! ac-list nc))
        ((eq? pm 'string-nil)          (handle:string-nil! ac-list nc))
        ((eq? pm 'string-hex-x)        (handle:string-hex-x! ac-list nc))
        ((eq? pm 'string-octal-long)   (handle:string-octal-long! ac-list nc))
        ((eq? pm 'string-octal-long1)  (handle:string-octal-long1! ac-list nc))
        ((eq? pm 'string-octal-short)  (handle:string-octal-short! ac-list nc))
        ((eq? pm 'string-hex-u)        (handle:string-hex-u! ac-list nc))
        ((eq? pm 'string-hex-u1)       (handle:string-hex-u1! ac-list nc))
        ((eq? pm 'string-hex-u2)       (handle:string-hex-u2! ac-list nc))
        ((eq? pm 'string-hex-u3)       (handle:string-hex-u3! ac-list nc))
        ((eq? pm 'string-hex-U)        (handle:string-hex-U! ac-list nc))
        ((eq? pm 'string-hex-U1)       (handle:string-hex-U1! ac-list nc))
        ((eq? pm 'string-hex-U2)       (handle:string-hex-U2! ac-list nc))
        ((eq? pm 'string-hex-U3)       (handle:string-hex-U3! ac-list nc))
        ((eq? pm 'string-hex-U4)       (handle:string-hex-U4! ac-list nc))
        ((eq? pm 'string-hex-U5)       (handle:string-hex-U5! ac-list nc))
        ((eq? pm 'string-hex-U6)       (handle:string-hex-U6! ac-list nc))
        ((eq? pm 'string-hex-U7)       (handle:string-hex-U7! ac-list nc))
        (else #f)))

(define (try-string-pm! ac-list nc pac pm)
  (cond ((memq pm '(string string-unmatched)) (handle:string! ac-list nc))
        ((eq? (get-kind pac) 'string-esc) (handle:string-esc! ac-list nc pm))
        (else #f)))

(define (try-ident-pm! ac-list nc pac pm)
  (cond ((memq pm '(ident ident-unmatched)) (handle:ident! ac-list nc))
        ((eq? (get-kind pac) 'ident-esc) (handle:ident-esc! ac-list nc pm))
        (else #f)))

(define (^handle:symmetric! base-sym backslash-sym esc-sym delim-char)
  (lambda (ac-list nc)
    (cond ((char=? nc #\\) (adorn-char nc esc-sym backslash-sym))
          ((char=? nc delim-char) (end-symmetric! ac-list nc base-sym))
          (else (adorn-char nc base-sym base-sym)))))

(define handle:ident!
  (^handle:symmetric! 'ident 'ident-backslash 'ident-esc #\|))

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

(define-macro (define-symmetric-handlers
                delim-char base-sym
                backslash-sym backslash-handler
                esc-sym
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
  `(begin (define ,u-handler (^handle:symmetric-hex-Uu!
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
                                      ,invalidate/maybe-end!))))

(define-symmetric-handlers
  #\| 'string
  'string-backslash handle:string-backslash!
  'string-esc
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

(define-symmetric-handlers
  #\| 'ident
  'ident-backslash handle:ident-backslash!
  'ident-esc
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

(define handle:ident-esc!
  (^handle:symmetric-esc! 'ident-backslash handle:ident-backslash!
                          'ident-nil handle:ident-nil!
                          'ident-hex-x handle:ident-hex-x!
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
                          'ident-octal-long handle:ident-octal-long!
                          'ident-octal-long1 handle:ident-octal-long1!
                          'ident-octal-short handle:ident-octal-short!))

(define (try-symmetric-pm! ac-list nc pac pm)
  (or (try-string-pm! ac-list nc pac pm)
      (try-ident-pm! ac-list nc pac pm)
      #f))
