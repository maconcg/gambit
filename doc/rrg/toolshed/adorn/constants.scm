;; Copyright (c) 2024 by Macon Gambill, all rights reserved.

(define whitespace-chars '(#\space #\newline #\tab))
(define compound-begin-chars '(#\( #\[ #\{))
(define compound-end-chars '(#\) #\] #\}))
(define abbrev-chars '(#\' #\` #\,))
(define delim-chars
  (append whitespace-chars compound-begin-chars compound-end-chars abbrev-chars
          '(#\" #\; #\| #\\)))

(define binary-chars '(#\0 #\1))
(define octal-chars (append binary-chars '(#\2 #\3 #\4 #\5 #\6 #\7)))
(define decimal-chars (append octal-chars '(#\8 #\9)))
(define hexadecimal-chars (append decimal-chars '(#\a #\b #\c #\d #\e #\f)))

(define mnemonic-escape-chars
  '(#\a #\b #\f #\n #\r #\t #\v #\" #\\ #\| #\? #\space))
(define directives
  (map string->list '("#!fold-case" "#!no-fold-case")))
(define dsssl-sharp-objects
  (map string->list '("#!key" "#!optional" "#!rest")))
(define sharp-objects
  (append dsssl-sharp-objects (map string->list '("#!eof" "#!void"))))
(define short-named-chars (map string->list '("esc" "nul" "tab")))
(define long-named-chars
  (map string->list '("null" "alarm" "backspace" "space" "newline" "return"
                      "delete" "escape" "page" "vtab" "linefeed")))
(define named-chars (append long-named-chars short-named-chars))
(define fvectors (map string->list '("#f32(" "#f64(")))
(define svectors (map string->list '("#s8(" "#s16(" "#s32(" "#s64(")))
(define uvectors (map string->list '("#u8(" "#u16(" "#u32(" "#u64(")))
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

(define sv-define-syntax
  (map string->list (plus-## '("define" "define-prim" "define-prim&proc"
                               "define-record-type"))))

(define sv-let-syntax
  (map string->list
       (plus-## '("let" "let*" "letrec" "letrec*" "parameterize"))))

(define lambda-syntax (map string->list (plus-## '("\x3bb;" "lambda"))))

(define mv-let-syntax
  (map string->list (plus-## '("let*-values" "let-values" "letrec*-values"
                               "letrec-values"))))

(define mv-define-syntax (map string->list (plus-## '("define-values"))))

(define case-lambda-syntax (map string->list (plus-## '("case-lambda"))))

;There's probably some way to populate this list programatically.
(define runtime-syntax
  (append sv-define-syntax
          sv-let-syntax
          lambda-syntax
          mv-let-syntax
          mv-define-syntax
          case-lambda-syntax
          (map string->list
               (plus-##
                '("and" "begin" "c-declare" "c-define" "c-define-type"
                  "c-initialize" "c-lambda" "case" "cond" "cond-expand"
                  "declare" "define-library" "define-macro"
                  "define-runtime-macro" "define-runtime-syntax"
                  "define-structure" "define-syntax" "define-type"
                  "define-type-of-thread" "delay" "delay-force" "do" "else"
                  "future" "guard" "if" "import" "include" "include-ci" "load"
                  "namespace" "or" "quasiquote" "quote" "r7rs-guard" "receive"
                  "set!" "syntax-error" "syntax-rules" "this-source-file"
                  "unless" "when")))))

(define else-is-syntax-syntax
  (map string->list (plus-## '("cond" "case" "macro-case-target"))))

(define define-mesgs
  '(sv-define defun-proc defun-param mv-define mv-define-rest))

(define let-mesgs '(named-let sv-let mv-let mv-let-rest))

(define lambda-bind-mesgs '(lambda-bind lambda-rest case-lambda-bind))

(define dsssl-bind-mesgs '(key-bind opt-bind key-init opt-init))

(define bind-mesgs
  (append dsssl-bind-mesgs define-mesgs let-mesgs lambda-bind-mesgs))

(define sublist-begin-mesgs
'( sublist-unmatched               sublist-begin
   subdefun-unmatched              subdefun-begin
   sublambda-bind-list-unmatched   sublambda-bind-list-begin
   sublet-sv-outer-unmatched       sublet-sv-outer-begin
   sublet-sv-inner-unmatched       sublet-sv-inner-begin
   sublet-mv-outermost-unmatched   sublet-mv-outermost-begin
   sublet-mv-outer-unmatched       sublet-mv-outer-begin
   sublet-mv-inner-unmatched       sublet-mv-inner-begin
   subdefine-mv-list-unmatched     subdefine-mv-list-begin
   subcase-lambda-outer-unmatched  subcase-lambda-outer-begin
   subcase-lambda-inner-unmatched  subcase-lambda-inner-begin
   subcompound-key-unmatched       subcompound-key-begin
   subcompound-opt-unmatched       subcompound-opt-begin ))

(define list-begin-mesgs
  (append sublist-begin-mesgs '(list-unmatched list-begin)))

(define sublist-delimiter-mesgs
  (append sublist-begin-mesgs
          '( sublist-end subdefun-end sublambda-bind-list-end
             sublet-sv-outer-end sublet-sv-inner-end sublet-mv-outermost-end
             sublet-mv-outer-end sublet-mv-inner-end subdef-mv-end
             subcase-lambda-inner-end subcompound-key-end
             subcompound-opt-end )))

(define list-delimiter-mesgs
  (append sublist-delimiter-mesgs list-begin-mesgs '(list-end)))

(define list-end-mesgs '(sublist-end list-end))

(define dsssl-compounds '(compound-key compound-opt))

(define binding-compounds
  (append '(defun lambda-bind-list let-sv-inner case-lambda-inner)
          dsssl-compounds))

(define compound-kinds
  (append '( list vector let-sv-outer let-mv-outermost let-mv-outer
             let-mv-inner define-mv-list case-lambda-outer )
          binding-compounds hvector-kinds))

(define ident/string-base-mesgs
  '( string datumc-string datumc-compound-string ident datumc-ident
     datumc-compound-ident defun-proc-ident defun-param-ident sv-define-ident
     mv-define-ident mv-define-rest-ident named-let-ident sv-let-ident
     mv-let-ident mv-let-rest-ident lambda-bind-list lambda-rest-ident
     case-lambda-bind-ident key-bind-ident opt-bind-ident rest-bind-ident
     key-init-ident opt-init-ident ))
