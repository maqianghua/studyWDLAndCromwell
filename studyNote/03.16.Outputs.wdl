version 1.0

task t {
    command {
        # do something
    }
    output {
        string out="out"
    }
}

workflow w {
    input {
        Array[Int] arr=[1,2]
    }
    scatter (i in arr) {
        call t
    }
    ouput {
        Array[String] t_out=t.out
    }
}