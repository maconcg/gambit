#!/usr/bin/env gsi-script
;; Copyright (c) 2024 by Macon Gambill, all rights reserved.

(define (main . args)
  (write-contents (file->char-list (car args))))

(define (file->char-list file)
  (call-with-input-file file
    (lambda (p) (read-all p read-char))))

(define (zero-pad char-list)
  (if (> 4 (length char-list))
      (zero-pad (cons #\0 char-list))
      char-list))

(define (hexify char)
  (if (char-alphabetic? char)
      (list char)
      (cons #\_ (zero-pad
                 (string->list (number->string (char->integer char) 16))))))

(define (indexify char-list)
  (let loop ((indexified '()) (rest char-list))
    (if (null? rest)
        (append '(#\# #\i #\n #\d #\e #\x #\-) (reverse indexified))
        (loop (append (reverse (hexify (car rest))) indexified) (cdr rest)))))

(define (t/rest char-list)
  (let loop ((t '()) (rest char-list))
    (if (null? rest)
        (cons (reverse t) '())
        (let ((nc (car rest)))
          (if (char=? nc #\})
              (cons (reverse t) rest)
              (loop (cons nc t) (cdr rest)))))))

(define linkify
  (let ((pre (string->list "@inlinefmt{html,@inlineraw{html,")))
    (lambda (char-list)
      (append pre '(#\< #\a #\space #\h #\r #\e #\f #\= #\")
              (indexify char-list)
              '(#\" #\> #\} #\})
              char-list
              pre '(#\< #\/ #\a #\> #\} #\})))))

(define (write-contents char-list)
  (let loop ((ppc #f) (pc #f) (rest char-list))
    (unless (null? rest)
      (let ((nc (car rest)))
        (write-char nc)
        (if (and (char=? nc #\{) (eqv? pc #\t) (eqv? ppc #\@))
            (let ((t/r (t/rest (cdr rest))))
              (let ((t (car t/r)) (r (cdr t/r)))
                (write-string (list->string (linkify t)))
                (loop #f #f r)))
            (loop pc nc (cdr rest)))))))
