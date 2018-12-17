version 1.0

task inc {
    input {
        Int i
    }
    command <<<
        python -c "print (~{i}+1)"
    >>>
    output {
        Int incremented=read_int(stdout())
    }
}
workflow wf {
    Array[Int] integers=[1,2,3,4,5]
    scatter (i in integers) {
        call inc {
            input :
                i=i
        }
    }
}