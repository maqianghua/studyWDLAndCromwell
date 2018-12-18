version 1.0

task test {
    input {
        Array[Object] in
    }
    command <<<
        /bin/do_work --obj=~{write_objects(in)}
    >>>
    output {
        File results = stdout()
    }
}