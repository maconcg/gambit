#!/usr/bin/env gsi-script

(load "adorn/adorn")

(define (main . args)
  (let ((source/css (if (null? args)
                        (error "No arguments given")
                        (let ((first (car args)) (rest (cdr args)))
                          (cond ((null? rest) (cons first "gambit.css"))
                                ((string=? first "-e")
                                 (cons (car rest) "gambit-examples.css"))
                                (else (cons (car rest) first)))))))
    (let ((source (car source/css)) (css (cdr source/css)))
      (let ((css-content (call-with-input-file css
                           (lambda (p) (read-line p #f)))))
        (let ((ac-list (adorn#reverse+simplify-kinds!
                    (adorn#adorn! (call-with-input-file source
                                    (lambda (p) (read-all p read-char))))))
              (base-filename (basename source)))
          (with-output-to-file (string-append
                                base-filename
                                (if (member css '("gambit.css"
                                                  "gambit-examples.css")
                                            string=?)
                                    ".html"
                                    ".alt.html"))
            (lambda ()
              (write-pre-css base-filename)
              (display css-content)
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
))))))))

(define (basename path-string)
  (let loop ((new '()) (old (reverse (string->list path-string))))
    (if (null? old)
        (list->string new)
        (let ((next (car old)))
          (if (char=? next #\/)
              (list->string new)
              (loop (cons next new) (cdr old)))))))

(define (write-pre-css title)
  (write-string (string-append #<<END
<!DOCTYPE html>
<html>  
<!-- Created by scm-to-html.scm -->
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
              (let ((char (adorn#get-char ac))
                    (kind (adorn#get-kind ac)))
                (if (eq? kind pk)
                    (begin (write-char-or-char-list (char->html-maybe-& char))
                           (loop kind (cdr rest)))
                    (begin (close-span pk)
                           (open-span kind)
                           (write-char-or-char-list (char->html-maybe-& char))
                           (loop kind (cdr rest)))))))))))

