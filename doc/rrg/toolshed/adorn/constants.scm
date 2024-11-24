;; Copyright (c) 2024 by Macon Gambill, all rights reserved.

(define delim-chars '(#\) #\( #\space #\newline #\tab #\" #\; #\| #\' #\` #\\))
(define whitespace-chars '(#\space #\newline #\tab))
(define compound-begin-chars '(#\( #\[ #\{))
(define compound-end-chars '(#\) #\] #\}))
(define binary-chars '(#\0 #\1))
(define octal-chars (append binary-chars '(#\2 #\3 #\4 #\5 #\6 #\7)))
(define decimal-chars (append octal-chars '(#\8 #\9)))
(define hexadecimal-chars (append decimal-chars '(#\a #\b #\c #\d #\e #\f)))

(define ident/string-mnemonic-escape-chars
  '(#\a #\b #\f #\n #\r #\t #\v #\" #\\ #\| #\? #\space))
(define directives '("#!fold-case" "#!no-fold-case"))
(define dsssl-sharp-objects '("#!key" "#!optional" "#!rest"))
(define sharp-objects (append dsssl-sharp-objects '("#!eof" "#!void")))
(define short-named-chars '("#\\esc" "#\\nul"))
(define long-named-chars
  '("#\\null" "#\\alarm" "#\\backspace" "#\\tab" "#\\space" "#\\newline"
    "#\\return" "#\\delete" "#\\escape" "#\\page" "#\\vtab" "#\\linefeed"))
(define fvector-strings '("#f32(" "#f64("))
(define svector-strings '("#s8(" "#s16(" "#s32(" "#s64("))
(define uvector-strings '("#u8(" "#u16(" "#u32(" "#u64("))
(define fvector-kinds '(f32vector f64vector))
(define svector-kinds '(s8vector s16vector s32vector s64vector))
(define uvector-kinds '(u8vector u16vector u32vector u64vector))
(define hvector-kinds (append fvector-kinds svector-kinds uvector-kinds))
(define datumc-kinds
  '( datumc datumc-compound datumc-string datumc-compound-string datumc-ident
     datumc-compound-ident ))
(define datumc-escape-kinds
  '( datumc-string-esc datumc-compound-string-esc datumc-ident-esc
     datumc-compound-ident-esc ))
(define comment-kinds (append '(linec nestc) datumc-kinds datumc-escape-kinds))
(define atmosphere-kinds (append '(whitespace directive) comment-kinds))

(define (plus-## strings)
  (append strings (map (lambda (s) (string-append "##" s)) strings)))

;; There's probably some way to populate this list programatically.
(define runtime-syntax
  (plus-##
   '("and" "begin" "c-declare" "c-define" "c-define-type" "c-initialize"
     "c-lambda" "case" "case-lambda" "cond" "cond-expand" "declare" "define"
     "define-library" "define-macro" "define-prim" "define-prim&proc"
     "define-record-type" "define-runtime-macro" "define-runtime-syntax"
     "define-structure" "define-syntax" "define-type" "define-type-of-thread"
     "define-values" "delay" "delay-force" "do" "future" "guard" "if" "import"
     "include" "include-ci" "\x3bb;" "lambda" "let" "let*" "let*-values"
     "let-values" "letrec" "letrec*" "letrec*-values" "letrec-values"
     "namespace" "or" "parameterize" "quasiquote" "quote" "r7rs-guard"
     "receive" "set!" "syntax-error" "syntax-rules" "this-source-file" "unless"
     "when")))

(define sv-define-syntax
  (plus-## '("define" "define-prim" "define-prim&proc" "define-record-type")))

(define sv-let-syntax
  (plus-## '("let" "let*" "letrec" "letrec*" "parameterize")))

(define else-is-syntax-syntax (plus-## '("cond" "case" "macro-case-target")))

(define define-mesgs '(sv-define mv-define defun-proc defun-param))
(define let-mesgs '(named-let sv-let mv-let))
(define lambda-bind-mesgs
  '(lambda-bind lambda-rest case-lambda-bind case-lambda-rest))
(define bind-mesgs (append define-mesgs let-mesgs lambda-bind-mesgs))

(define sublist-begin-mesgs '(sublist-unmatched sublist-begin))
(define list-begin-mesgs
  (append sublist-begin-mesgs '(list-unmatched list-begin)))
(define sublist-delimiter-mesgs (append sublist-begin-mesgs '(sublist-end)))
(define list-delimiter-mesgs
  (append sublist-delimiter-mesgs list-begin-mesgs '(list-end)))
(define list-end-mesgs '(sublist-end list-end))

(define dsssl-compounds '(key-compound opt-compound))
(define compound-kinds (append '(list vector) dsssl-compounds hvector-kinds))

(define ident/string-base-mesgs
  '( string datumc-string datumc-compound-string ident datumc-ident
     datumc-compound-ident defun-proc-ident defun-param-ident sv-define-ident
     mv-define-ident named-let-ident sv-let-ident mv-let-ident
     lambda-bind-ident lambda-rest-ident case-lambda-bind-ident
     case-lambda-rest-ident key-param-ident key-init-param-ident
     opt-param-ident opt-init-param-ident rest-param-ident ))
