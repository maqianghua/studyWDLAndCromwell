version 1.0 

task test {
    input {
        String var
    }
    command {
        ./script ${var}
    }
    output {
        String vlaue = read_string(stdout())
    }
}

task test2{
    input {
        Array[String] array
    }
    command {
        ./script ${write_line(array)}
    }
    output {
        Int vlaue = read_int(stdout())
    }
}

workflow wf {
    call test as x {input: var = "x"}
    call test as y {input: var= "y"}
    Array[String] strs = [x.vlaue,y.vlaue]
    call test2 as z {input: array = strs}
}