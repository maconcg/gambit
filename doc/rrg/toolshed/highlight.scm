#!/usr/bin/env gsi-script

(load "adorn.scm")

(define (main . args)
  (let ((source (car args))
        (css (call-with-input-file (if (null? (cdr args))
                                       "gambit.css"
                                       (cadr args))
               (lambda (p) (read-line p #f)))))
    (let ((ac-list (reverse+simplify-kinds!
                    (adorn! (call-with-input-file source
                              (lambda (p) (read-all p read-char))))))
          (basename (let loop ((bn '()) (rest (reverse (string->list source))))
                      (if (null? rest)
                          (list->string bn)
                          (let ((next (car rest)))
                            (if (char=? #\/ next)
                                (list->string bn)
                                (loop (cons next bn) (cdr rest))))))))
      (let ((bn-no-extension (let loop ((ne '()) (rest (string->list source)))
                               (if (null? rest)
                                   (list->string (reverse ne))
                                   (let ((next (car rest)))
                                     (if (char=? #\. next)
                                         (list->string (reverse ne))
                                         (loop (cons next ne) (cdr rest))))))))
        (with-output-to-file (string-append bn-no-extension ".html")
          (lambda ()
            (write-pre-css basename)
            (display css)
            (write-string #<<END
-->
</style>
</head>
<body lang="en">
<pre class="lisp-preformatted">

END
)
            (write-ac-list ac-list)
            (write-string #<<END
</pre>
</body>

END
)))))))

(define (write-pre-css title)
  (write-string (string-append #<<END
<!DOCTYPE html>
<html>  
<!-- Created by highlight.scm -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>
END
title #<<END
</title>
<meta name="resource-type" content="document">
<meta name="viewport" content="width=device-width,initial-scale=1">
<style type="text/css">
<!--

END
)))

(define html-safe
  (append '(#\space #\newline)
          (char-set->list (char-set-intersection char-set:ascii
                                                 char-set:letter+digit))))

(define (char->html-maybe-& c)
  (if (member c html-safe char=?)
      c
      (append '(#\& #\#)
              (string->list (number->string (char->integer c)))
              '(#\;))))

(define (write-char-or-char-list c)
  (if (list? c)
      (for-each write-char c)
      (write-char c)))

(define (write-ac-list ac-list)
  (let ((nil-spans '(default whitespace)))
    (let ((open-span (lambda (kind)
                       (unless (memq kind nil-spans)
                         (write-string (string-append "</span><span class=\""
                                                      (symbol->string kind)
                                                      "\">")))))
          (close-span (lambda (kind)
                        (unless (memq kind nil-spans)
                          (write-string "</span>")))))
      (let loop ((pk 'default) (rest ac-list))
        (if (null? rest)
            (close-span pk)
            (let ((ac (car rest)))
              (let ((char (get-char ac))
                    (kind (get-kind ac)))
                (if (eq? kind pk)
                    (begin (write-char-or-char-list (char->html-maybe-& char))
                           (loop kind (cdr rest)))
                    (begin (close-span pk)
                           (open-span kind)
                           (write-char-or-char-list (char->html-maybe-& char))
                           (loop kind (cdr rest)))))))))))
