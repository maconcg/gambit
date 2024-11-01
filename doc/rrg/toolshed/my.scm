(define css-color-template #<<END
body {
    color: <fg-main>;
    background-color: <bg-main>;
}

a:link {color: <link>}
a:visited {color: <link-visited>}
hr {color: <border>}
span.todo {background-color: <todo>}
.chapter-level-extent pre {border-left-color: <fg-main>}

dl.first-deftp, dl.first-deftypefn, dl.first-deftypevr {
    border-top-color: <border>;
    dt {
        code.def-code-arguments {color: <def-var>}
        span.category-def {color: <category-def>}
        code.def-code-arguments span.bracket {color: <fg-alt>}
    }
    dd {
        background-color: <bg-main>;
        p var.var, li var.var {color: <def-var>}
    }
    pre {
        span.abbrev {color: <abbrev>}
        span.boolean {color: <boolean>}
        span.box {color: <box>}
        span.char {color: <char>}
        span.datumc, span.linec, span.nestc {color: <codecomment>}
        span.dot {color: <dot>}
        span.keyword {color: <keyword>}
        span.list {color: <list>}
        span.ok {color: <ok>}
        span.problem {background-color: <problem>}
        span.serial {color: <serial>}
        span.sharp {color: <sharp>}
        span.string {color: <string>}
        span.string-escape {color: <string-escape>}
        span.here-string {color: <here-string>}
        span.runtime-syntax {color: <runtime-syntax>}
    }
}

dl.first-deftp, dl.first-deftypevr {
    p i.slanted {color: <emphasis>}
}

dl.first-deftp {
    background-color: <bg-deftp>;
    background-image: linear-gradient(90deg, <deftp-l>, <deftp-r> 35%);
}

dl.first-deftypefn {
    background-color: <bg-deftypefn>;
    background-image: linear-gradient(90deg, <deftypefn-l>, <deftypefn-r> 35%);
    span.paren {color: <list>}
    dd pre span.exception {color: <exception>}
}

dl.first-deftypevr {
    background-color: <bg-deftypevr>;
    background-image: linear-gradient(90deg, <deftypevr-l>, <deftypevr-r> 35%);
}

END
)
