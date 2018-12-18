version 1.0

task test {
    Object input
    command <<<
        /bin/do_work --obj=~{write_object(input)}
    >>>
    output {
        File results=stdout()
    }
}