;; Covers §6.2.5 of R⁷RS (Syntax of numerical constants)

;; Numbers:
3.14 3.14e0 3.14L0 3.14E0 3.14f0 #i3.14 #d3.14 #i#d3.14s12 #d#i3.14
+1 -1 11 +NaN.0 +nan.0 -nAN.0 +nAn.0 -inf.0 -inF.0 +INF.0 -Inf.0 #b11
#b#e0 #e#b1 #b#i0 #i#b1 #O#e7 #e#O6 #X#Ee #e#xe #x#if #x#ICE #e#d10e0
#e+3 #I-9 #d#i-4 #D#I+9l1 .4 -.3 +.4

;; Not numbers:
#b#i12 #b21 #o87 #da1 #xg2 #e#d10ea #o7e1 + - ++ -- +- -+ + 1+ 1- +1+
-1- +nan.1 +inf.00 -inf.0e1 #e+ #I+ .. .4. ..2
