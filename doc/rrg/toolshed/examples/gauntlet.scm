;; Chars (R⁷RS + Gambit extensions):
#\N #\Nu #\n #\nU #\nu #\nul #\null #\nulls
#\s #\spac #\space #\spaceballs
#\e #\es #\esc #\esca #\escap #\escapade #\escape #\escaped
#\x #\x0 #\x01 #\x0g #\x0123456789 #\x0123#
#\u012 #\u0123 #\u012g #\u01234
#\U0123456 #\U01234567 #\U012345678
;==============================================================================
;; Numbers (covers §6.2.5 of R⁷RS):
3.14 3.14e0 3.14L0 3.14E0 3.14f0 #i3.14 #d3.14 #i#d3.14s12 #d#i3.14
+1 -1 11 +NaN.0 +nan.0 -nAN.0 +nAn.0 -inf.0 -inF.0 +INF.0 -Inf.0 #b11
#b#e0 #e#b1 #b#i0 #i#b1 #O#e7 #e#O6 #X#Ee #e#xe #x#if #x#ICE #e#d10e0
#e+3 #I-9 #d#i-4 #D#I+9l1 .4 -.3 +.4 #d#I+.8 #e#X+F
;; Not numbers:
#b#i12 #b21 #o87 #da1 #xg2 #e#d10ea #o7e1 + - ++ -- +- -+ + 1+ 1- +1+
-1- +nan.1 +inf.00 -inf.0e1 #e+ #I+ .. .4. ..2
;==============================================================================
;; Strings/identifiers:
"\\\t\r\a\ffic" "Newline at my end\n" "one\|string" |one\"idntifier\||
"\\\u012345\U0123456789\\x0;\x0;" "\u012three"
#;#;#; "\"one string on this line" "is not" "commented" #|" ";"""|# "" #;"\""
#| 4 strings of increasing length: |# "" "\"" "\"\"" "\"\"\"" "\"\"\"\""
(define a-here-string #<<end-of-this-here-string
#<<end-of-this-here-string
#!eof
end-of-this-here-string 
 end-of-this-here-string
"" \" \\
end-of-this-here-string
)
;==============================================================================
;; Compound data:
#| 3 are empty: |# ((()(( #;#;#;empty #|#|lists|# are|#more prominent))))((()))
#| 2 empty vectors: |# #(#(#()#(#(#(#f64( #| #;#;#;#;vectors #|too ;|#|# ))))))
( #| “if” is runtime syntax |# if x y z)
( #| “if” is not runtime syntax |# not if)
#| One empty list: |# ((( ;;
                         )       ))
(cond ((not (auxiliary-syntax else)) => (lambda x (else #false)))
      (else auxiliary-syntax))
#|evaluates to a one-element list: |# (list #;((λ (x) (/ x (+ x (* x 6)))) 8)4)
;==============================================================================
;; Bindings: 
;;
;; The scope of a “define-like” binding extends beyond its list; the
;; scope of a “let-like” binding does not.  This lets us consistently
;; use the same rules for “regular” define, “defun” define, let, etc.
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
(f11 'A b: 'B) ;; Keyword parameters are the same color as keyword: arguments.

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
