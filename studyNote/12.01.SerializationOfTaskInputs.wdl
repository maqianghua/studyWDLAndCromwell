version 1.0

task output_example {
    input {
        String s
        Int i
        Float f
    }
    command {
        python do_work.py ${s} ${i} ${f}
    }
}