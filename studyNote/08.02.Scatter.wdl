version 1.0

task inx {
    input {
        Int i
    }
    command <<<
        python -c "print (~{i}+i)"
    >>>
    output {
        Int incremented=read_int(stdout())
    }
}
task sum{
    input {
        Array[Int] ints
    }
    command <<<
        python -c "print(~(sep="+" ints))"
    >>>
    output {
        Int sum=read_int(stdout())
    }
}

workflow wf {
    Array[Int] integers=[1,2,3,4,5]
    scatter (i in integers) {
        call inc {input : i=i}
    }
    call sum {
        input :
            ints=inc.incremented
    }
}