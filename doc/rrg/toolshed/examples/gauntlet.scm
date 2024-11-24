#!/usr/bin/env gsi-script

(import (srfi 19))  ;; for time procedures
(import (srfi 48))  ;; for format

(define (get-date)
  (time-utc->date (current-time time-utc)))

(format #t
        "current UTC time: ~a\n"
        (date->string (get-date)))

;==============================================================================
;; Chars (R⁷RS + Gambit extensions):
#\N #\Nu #\n #\nU #\nu #\nul #\null #\nulls
#\s #\spac #\space #\spaceballs
#\e #\es #\esc #\esca #\escap #\escapade #\escape #\escaped
#\x #\x0 #\x01 #\x0g #\x0123456789 #\x0123#
#\u012 #\u0123 #\u012g #\u01234
#\U0123456 #\U01234567 #\U012345678
;==============================================================================
;; Numbers (covers §6.2.5 of R⁷RS):
3.1 1.1e+8 2.2F-1 3.4e0 3.1L0 3.5E0 3.7f0 #i3.8 #d3.9 #i#d3.5s12 #d#i3.1 +1 -1
+NaN.0 +nan.0 -nAN.0 +nAn.0 -inf.0 -inF.0 +INF.0 -Inf.0 #b11 #b#e0 #e#b1 #b#i0
#i#b1 #O#e7 #e#O6 #X#Ee #e#xe #x#if #x#ICE #e#d10e0 #e+3 #I-9 #d#i-4 #D#I+9l1 4
44 .4 .4s4 -.3 +.4 #d#I+.8 #e#X+F 2. #d2. #e#d2. #d#E2. #D.8 #e.8 #e9. #D#E.0
;; Not numbers:
#b#i12 #b21 #o87 #da1 #xg2 #e#d10ea #o7e1 + - ++ -- +- -+ + 1+ 1- +1+
-1- +nan.1 +inf.00 -inf.0e1 #e+ #I+ .. .4. ..2 #D#E.
;==============================================================================
;; Strings/identifiers:
"\\\t\r\a\ffic" "Newline at my end\n" " one\| string\"" | one \" identifier \||
"\\\u012345\U0123456789\\x0;\x0;" "\u012three"
#;#;#;"\"2 strings on this line" "are not" "commented"#|" ";"""|# "" #;"\"""\""
#| 4 strings of increasing length: |# "" "\"" "\"\"" "\"\"\"" "\"\"\"\""
(define a-here-string #<<end-of-this-here-string
#<<end-of-this-here-string
#!eof
end-of-this-here-string 
 end-of-this-here-string
"" " \\\
end-of-this-here-string
)
;==============================================================================
;; Compound data:
#| 3 are empty: |# ((()(( #;#;#;empty #|#|lists|# are|#more prominent))))((()))
#| 2 empty vectors: |# #(#(#()#(#(#(#f64( #| #;#;#;#;vectors #|too ;|#|# ))))))
( #| “if” is runtime syntax: |# if x y z)
( #| “if” is not runtime syntax: |# not if)
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

(define identity (lambda thing thing))
(define identity (lambda thing #;#;#; thing thing #|thing|# thing thing))

(define v0 98) (define v1 #f) (define v2 #t) (define v3 #!void) (define v4 #())
(define v5 (quote #&50)) (define v6 |r\r|) (define v7 "t\tt") (define v8 #\tab)

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
;==============================================================================
;; Booleans/homogeneous vectors:
#t #tr #tru #true #truer
#f #fa #fal #fals #false #falser
#f #f3 #f32 #f32( ) #f32( 1. ) #f62( )
#s #s1 #s16 #s16( ) #s16( 1 ) #s17( )
#u #u8 #u8( ) #u8( 1 ) #u64( 1 ) #u2( )
;==============================================================================
;; Boxes:
#&f #&#f #&#\f #&|\f| #&f: #&"\f" #&#\newline #&20
;==============================================================================
;; Labels/references:
#| cicular list: |#               '#0=(1 2 3 . #0#)
#| (repl-result-history-ref 0) |#  # (# 'x)
#| (repl-result-history-ref 1) |#  ## (## 'x)
#| (repl-result-history-ref 2) |#  ### (### 'x)
#| (serial-number->object 0)   |#  #0 (#0 'x)
#| (serial-number->object 1)   |#  #1 (#1 'x)
#| (serial-number->object 78)  |#  #78 (#78 'x)
;==============================================================================
;; Directives/atmosphere:
#;#; #!fold-case #!no-fold-case commented commented not-commented
#!no-fold-case
not-commented #|#|#|#|#|#|;;commented#;|#|#|##|#|#||#|#|#|#|#|# not-commented
#; ;; next compound datum is commented
#(0 1 2 3 #(0 1 #()))
not-commented
#;#;#; ;; next three compound data are commented
() #u64() (     ) not-commented
