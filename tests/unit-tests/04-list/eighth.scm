(include "#.scm")

(define bool #f)

(define z0  (list))
(define z1  (list 100))
(define z2  (list 100 101))
(define z3  (list 100 101 102))
(define z4  (list 100 101 102 103))
(define z5  (list 100 101 102 103 104))
(define z6  (list 100 101 102 103 104 105))
(define z7  (list 100 101 102 103 104 105 106))
(define z8  (list 100 101 102 103 104 105 106 107))
(define z9  (list 100 101 102 103 104 105 106 107 108))
(define z10 (list 100 101 102 103 104 105 106 107 108 109))

(check-tail-exn type-exception? (lambda () (eighth z0)))
(check-tail-exn type-exception? (lambda () (eighth z1)))
(check-tail-exn type-exception? (lambda () (eighth z2)))
(check-tail-exn type-exception? (lambda () (eighth z3)))
(check-tail-exn type-exception? (lambda () (eighth z4)))
(check-tail-exn type-exception? (lambda () (eighth z5)))
(check-tail-exn type-exception? (lambda () (eighth z6)))
(check-tail-exn type-exception? (lambda () (eighth z7)))
(check-equal? (eighth z8) 107 )
(check-equal? (eighth z9) 107 )
(check-equal? (eighth z10) 107 )
(check-tail-exn type-exception? (lambda () (eighth bool)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (eighth)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (eighth z10 z10)))