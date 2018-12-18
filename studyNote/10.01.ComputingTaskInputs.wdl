version 1.0

task test {
    input {
        Int i
        Float f
    }
    String s ="${i}"
    command {
        ./script.sh -i ${s} -f ${f}
    }
}