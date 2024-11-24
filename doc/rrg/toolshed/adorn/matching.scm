(define (memc c l) (member c l char=?))
(define (memc-ci c l) (member c l char-ci=?))

(define (char-list-backmatch goal actual)
  (let backmatch-loop ((goal (reverse goal)) (actual-rest (reverse actual)))
    (if (null? goal)
        actual
        (and (not (null? actual-rest))
             (char=? (car goal) (car actual-rest))
             (backmatch-loop (cdr goal) (cdr actual-rest))))))

(define (backmatch goal actual)
  (let ((cl-goal (if (string? goal) (string->list goal) goal))
        (cl-actual (if (string? actual) (string->list actual) actual)))
    (char-list-backmatch cl-goal cl-actual)))

(define (char-list-could-match? goal actual)
  (or (null? actual)
      (and (not (null? goal))
           (char=? (car goal) (car actual))
           (char-list-could-match? (cdr goal) (cdr actual)))))

(define (could-match? goal actual)
  (let ((cl-goal (if (string? goal) (string->list goal) goal))
        (cl-actual (if (string? actual) (string->list actual) actual)))
    (char-list-could-match? cl-goal cl-actual)))

(define (could-match-one-of? goals actual)
  (and (not (null? goals))
       (or (could-match? (car goals) actual)
           (could-match-one-of? (cdr goals) actual))))

(define (achievable-goals goals actual)
  (let loop ((old goals) (new '()))
    (if (null? old)
        new
        (let ((goal (car old)))
          (cond ((could-match? goal actual) (loop (cdr old) (cons goal new)))
                (else (loop (cdr old) new)))))))

(define (backmatch-one-of goals actual)
  (let loop ((achievable (achievable-goals goals actual)))
    (and (not (null? achievable))
         (or (backmatch (car achievable) actual) (loop (cdr achievable))))))

(define (matches? goal actual)
  (let ((cl-goal (if (string? goal) (string->list goal) goal))
        (cl-actual (if (string? actual) (string->list actual) actual)))
    (or (and (null? cl-goal) (null? cl-actual))
        (and (not (or (null? cl-goal) (null? cl-actual)))
             (char=? (car cl-goal) (car cl-actual))
             (matches? (cdr cl-goal) (cdr cl-actual))))))

(define (matches-one-of? goals actual)
  (let loop ((achievable (achievable-goals goals actual)))
    (and (not (null? achievable))
         (or (matches? (car achievable) actual) (loop (cdr achievable))))))
