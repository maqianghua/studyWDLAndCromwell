version 1.0

task test {
    input {
        Array[File] a
        Array[File]+ b
        Array[File]? c
        # File+ d <-- 不能这样做，+仅能应用于数组Arrays
    }
    command {
        /bin/mycmd ${sep=" " a}
        /bin/mycmd ${sep="," b}
        /bin/mycmd ${write_lines(c)}
    }
}
workflow wf {
    call test
}