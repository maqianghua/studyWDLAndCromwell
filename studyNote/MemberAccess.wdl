version 1.0

workflow wf {
    input {
        Object obj
        Object foo
    }
    # this would cause a syntax error,
    # because foo is defined twice in the same namespace
    call foo {
        input: 
            var = obj.attr #Object attribute
    }
    call foo as foo2 {
        input:
            var =foo.out #Task output
    }
}