version 1.0

task t1 {
    input {
        String s
        Int x
    }
    command {
        ./script --action=${s} -x${x}
    }
    output {
        Int count = read_int(stdout())
    }
}
task t2 {
    input {
        String s
        Int t
        Int x
    }
    command {
        ./script2 --action=${s} -x${x} --other=${t}
    }
    output {
        Int count = read_int(stdout())
    }
}
task t3 {
    input {
        Int y
        File ref_file #不做任何操作
    }
    command {
        python -c "print${y}+1"
    }
    output {
        Int incr = read_int(stdout())
    }
}
workflow wf {
    input {
        Int int_val
        Int int_val2=10
        Array[Int] my_ints
        File ref_file
    }
    String not_an_input="hello"
    call t1 {
        input :
            x=int_val
    }
    call t2 {
        input :
            x=int_val,
            t=t1.count
    }
    scatter(i in my_ints){
        call t3 {
            input :
                y=i,
                ref=ref_file
        }
    }
}