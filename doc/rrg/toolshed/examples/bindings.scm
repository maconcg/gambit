#|
The scope of a “define-like” binding extends beyond its list; the
scope of a “let-like” binding does not.  This lets us consistently use
the same rules for “regular” define, “defun” define, let, etc.
|#

(lambda x 
    (let ((y (car x)))
      (* y y)))

(lambda (x) (* x x))
(lambda (|\x78;|) (* |x| |\u0078|))
(lambda (x) (let-values (((a b c) (values x x x))) (* a b)))

(define |squ\x61;re| (λ (x) (* x x)))
(define square (lambda (x) (* x x)))
(define (square x) (* x x))

(define (fact i)
  (let iterate ((i i) (product 1))
    (if (positive? i)
        (iterate (- i 1) (* i product))
        product)))

(define identity (lambda thing thing)
(define identity (lambda thing #;#;#; thing thing #|thing|# thing thing))

;; from tests/mix.scm
(define (f1) 'ok)
(define (f2 a) (list a))
(define (f3 . a) (list a))
(define (f4 a . b) (list a b))

(define (f5 a #!optional) (list a))
(define (f6 a #!optional b) (list a b))
(define (f7 a #!optional (b (list a b))) (list a b))

(define (f8 a #!rest b) (list a b))

(define (f9 a #!key) (list a))
(define (f10 a #!key b) (list a b))
(define (f11 a #!key (b (list a b))) (list a b))
(f11 'A b: 'B) #| Keyword parameters are the same color as
                  keyword: actual arguments. |#

(define (f12 a #!optional #!rest b) (list a b))
(define (f13 a #!optional b #!rest c) (list a b c))

(define (f14 a #!optional #!key) (list a))
(define (f15 a #!optional #!key b) (list a b))
(define (f16 a #!optional #!key (b (list a b))) (list a b))
(define (f17 a #!optional b #!key) (list a b))
(define (f18 a #!optional b #!key c) (list a b c))
(define (f19 a #!optional (b (list a b c)) #!key (c (list a b c))) (list a b c))

(define (f20 a #!rest b #!key) (list a b))
(define (f21 a #!rest b #!key c) (list a b c))
(define (f22 a #!rest b #!key (c (list a b c))) (list a b c))

(define (f23 a #!optional #!rest b #!key) (list a b))
(define (f24 a #!optional #!rest b #!key c) (list a b c))
(define (f25 a #!optional #!rest b #!key (c (list a b c))) (list a b c))
(define (f26 a #!optional b #!rest c #!key) (list a b c))
(define (f27 a #!optional (b (list a b c)) #!rest c #!key) (list a b c))
(define (f28 a #!optional b #!rest c #!key d) (list a b c d))
(define (f29 a #!optional (b (list a b c d)) #!rest c #!key (d (list a b c d))) (list a b c d))

(define (f30 a #!optional #!key . b) (list a b))
(define (f31 a #!optional #!key b . c) (list a b c))
(define (f32 a #!optional #!key (b (list a b)) . c) (list a b c))
(define (f33 a #!optional b #!key . c) (list a b c))
(define (f34 a #!optional (b (list a b c)) #!key . c) (list a b c))
(define (f35 a #!optional b #!key c . d) (list a b c d))
(define (f36 a #!optional (b (list a b c d)) #!key (c (list a b c d)) . d) (list a b c d))
